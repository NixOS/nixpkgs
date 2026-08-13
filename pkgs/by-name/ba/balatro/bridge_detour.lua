--[[
The game Balatro is implemented in Lua, with the standard LÖVE SDK.  However,
each store that it's sold on (Steam, Google Play, Xbox PC, etc.) has its own SDK
to provide features like cloud saving and achievement unlocking.

To allow the same platform-agnostic Lua codebase to be deployed in all these
contexts, each one has a custom bridge - `love.platform`.  This allows the game
to call `writeSaveFile` and trust that it will be handled appropriately for
whatever platform the player has available.  Unfortunately, that bridge is not
supplied by LÖVE, and is therefore missing from Nix's `pkgs.love`.

This file implements the functions that would otherwise utilize that missing
bridge.  It was created by finding all of the `love.platform` callsites in the
Balatro codebase, putting them in this file, and asking Gemini to implement a
Linux version.
]]

love.platform = love.platform or {}
package.loaded["love.platform"] = love.platform

local FileOperationStatus = {
  SUCCESS = 0,
  FETCH_ERROR = 1,
  CLOUD_SAVE_ERROR = 2,
  CONFLICT = 3,
  OFFLINE = 4,
  LOAD_ERROR = 5,
  NOT_FOUND = 6
}

function love.platform.init(onInitSuccess, onInitFailure)
  love.filesystem.setIdentity("balatro")

  if onInitSuccess then
    onInitSuccess(love.system.getOS(), love.platform.getLocalPlayerName())
  end
  return true
end

function love.platform.setOnPlatformStatusChangedCallback(callback)
  if callback then
    callback(false, "Cloud unavailable.")
  end
end

function love.platform.earlyInit() end
function love.platform.update(dt) end
function love.platform.shutdown() end


function love.platform.getPlatformId()
  return love.system.getOS()
end

function love.platform.getLocalPlayerName()
  return os.getenv("USER") or os.getenv("LOGNAME") or "Player"
end

function love.platform.getLocalPlayerAvatar()
  return nil
end

function love.platform.isPremium()
  return true
end

function love.platform.isArcade()
  return false
end

function love.platform.isFirstTimePlaying()
  return not love.platform.saveGameExists("1", "profile.jkr")
end

function love.platform.isOffline()
  -- If the game ever uses this for more than showing the offline warning, we
  -- should set this back to true
  return false
end

function love.platform.getNotchPosition()
  return nil
end


-- Different builds use different file APIs; therefore, we implement both the
-- thin wrapper around the framework's filesystem module and the more complex
-- signatures with individual save slots.
love.platform.localGetInfo = love.filesystem.getInfo
love.platform.localRead = love.filesystem.read
love.platform.localWrite = love.filesystem.write
love.platform.localRemove = love.filesystem.remove
love.platform.localCreateDirectory = love.filesystem.createDirectory


-- some versions store their settings files in `common/`
function love.filesystem.getInfo(filename, ...)
  local info = love.platform.localGetInfo(filename, ...)

  if not info then
    info = love.platform.localGetInfo("common/" .. filename, ...)
  end

  return info
end

function love.filesystem.read(filename, ...)
  local content, size = love.platform.localRead(filename, ...)

  if not content then
    content, size = love.platform.localRead("common/" .. filename, ...)
  end

  return content, size
end


function love.platform.writeSaveGame(profile, filename, data)
  local parent = tostring(profile)

  if not love.platform.localGetInfo(parent) then
    love.platform.localCreateDirectory(parent)
  end

  return love.platform.localWrite(parent .. "/" .. filename, data)
end

function love.platform.loadSaveGame(profile, filename)
  local parent = tostring(profile)
  return love.platform.localRead(parent .. "/" .. filename)
end

function love.platform.saveGameExists(profile, filename)
  local parent = tostring(profile)
  return love.platform.localGetInfo(parent .. "/" .. filename) ~= nil
end

function love.platform.deleteSaveGameFile(profile, filename)
  local parent = tostring(profile)
  return love.platform.localRemove(parent .. "/" .. filename)
end

function love.platform.deleteSaveGame(profile)
  local parent = tostring(profile)
  return love.platform.localRemove(parent)
end

local load_game_callback
local save_game_callback

function love.platform.setLoadGameCallback(callback)
  load_game_callback = callback
end

function love.platform.loadGameFile(filename)
  local content, size = love.filesystem.read(filename)

  if load_game_callback then
    if content then
      load_game_callback(filename, FileOperationStatus.SUCCESS, "", content, nil, nil)
    else
      load_game_callback(filename, FileOperationStatus.NOT_FOUND, "File not found", nil, nil, nil)
    end
  end
end


function love.platform.setOnSaveInitializedCallback(callback)
  if callback then
    callback()
  end
end

function love.platform.setSaveGameCallback(callback)
  save_game_callback = callback
end

function love.platform.saveGameFile(filename, data)
  local success, msg = love.filesystem.write(filename, data)
  if save_game_callback then
    if success then
      save_game_callback(filename, FileOperationStatus.SUCCESS, "", data, nil, nil)
    else
      save_game_callback(filename, FileOperationStatus.CLOUD_SAVE_ERROR, msg, nil, nil, nil)
    end
  end
end


-- no-ops when there's no cloud saving
function love.platform.runLoadGameCallbacks() end
function love.platform.runSaveGameCallbacks() end
function love.platform.resolveConflict(file, content, conflictId) end


function love.platform.unlockAchievement(achievementId)
  love.filesystem.append(
    "unlock_awards.lua",
    string.format("love.platform.unlockAchievement(%q)\n", achievementId)
  )
end

function love.platform.unlockAward(awardName)
  love.filesystem.append(
    "unlock_awards.lua",
    string.format("love.platform.unlockAward(%q)\n", awardName)
  )
end


function love.platform.event(name, ...) end
function love.platform.hideSplashScreen() end
function love.platform.anyButtonPressed() return false end

--[[ these are checked before they're used by the game, so we don't have to
--   support them
function love.platform.requestReview() end
function love.platform.requestTrackingPermission() end
function love.platform.setProfileButtonActive(active) end
function love.platform.authenticateLocalPlayer() end
]]

if love.graphics then
  if love.graphics.isActive and not love.graphics.checkActive then
    love.graphics.checkActive = love.graphics.isActive
  end

  love.graphics.beginFrame = love.graphics.beginFrame or function() end
end
