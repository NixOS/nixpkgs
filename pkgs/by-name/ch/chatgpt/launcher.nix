# Electron rewrites bundled plugin manifests, so they need a writable copy.
{
  flock,
  writeShellApplication,
}:

writeShellApplication {
  name = "chatgpt-launcher";

  runtimeInputs = [ flock ];

  text = ''
    : "''${CHATGPT_EXECUTABLE:?}"
    : "''${CHATGPT_RESOURCES_SOURCE:?}"
    : "''${CHATGPT_RESOURCES_CACHE_LABEL:?}"

    cacheHome="''${XDG_CACHE_HOME:-''${HOME:?XDG_CACHE_HOME and HOME are unset}/.cache}"
    cacheRoot="$cacheHome/chatgpt/bundled-plugins"
    resourcesSourceHash=$(printf '%s' "$CHATGPT_RESOURCES_SOURCE" | sha256sum)
    resourcesSourceHash="''${resourcesSourceHash%% *}"
    cacheKey="$CHATGPT_RESOURCES_CACHE_LABEL-$resourcesSourceHash"
    resourcesPath="$cacheRoot/$cacheKey"

    mkdir -p "$cacheRoot/.locks"
    resourcesLockPath="$cacheRoot/.locks/$cacheKey.lock"
    exec {resourcesLockFd}> "$resourcesLockPath"
    flock --shared "$resourcesLockFd"

    stagingLockPath="$cacheRoot/.locks/staging-v1.lock"
    exec {stagingCleanupLockFd}> "$stagingLockPath"
    if flock --exclusive --nonblock "$stagingCleanupLockFd"; then
      for abandonedStagingPath in "$cacheRoot"/.chatgpt-staging-v1-*; do
        if [[ -d "$abandonedStagingPath" ]] && ! rm -rf -- "$abandonedStagingPath"; then
          echo "Failed to remove abandoned ChatGPT bundled-plugin staging directory: $abandonedStagingPath" >&2
        fi
      done
    fi
    exec {stagingCleanupLockFd}>&-

    requiredResourcePaths=()
    for requiredResourceName in codex codex-code-mode-host cua_node native rg; do
      requiredResourcePath="$CHATGPT_RESOURCES_SOURCE/$requiredResourceName"
      if [[ ! -e "$requiredResourcePath" ]]; then
        echo "Missing ChatGPT bundled-plugin resource: $requiredResourcePath" >&2
        exit 1
      fi
      requiredResourcePaths+=("$requiredResourcePath")
    done

    if [[ ! -f "$resourcesPath/.complete" ]]; then
      exec {stagingWriterLockFd}> "$stagingLockPath"
      flock --shared "$stagingWriterLockFd"
      stagingPath=$(mktemp -d "$cacheRoot/.chatgpt-staging-v1-$cacheKey.XXXXXXXX")
      trap 'rm -rf -- "$stagingPath"' EXIT

      ln -s "''${requiredResourcePaths[@]}" "$stagingPath"
      cp -R "$CHATGPT_RESOURCES_SOURCE/plugins" "$stagingPath/plugins"
      chmod -R u+w "$stagingPath/plugins"
      touch "$stagingPath/.complete"

      # Flush the payload and commit marker before exposing the cache atomically.
      sync --file-system "$stagingPath"

      if mv -T "$stagingPath" "$resourcesPath" 2>/dev/null; then
        sync --file-system "$cacheRoot"
        trap - EXIT
      elif [[ -f "$resourcesPath/.complete" ]]; then
        rm -rf -- "$stagingPath"
        trap - EXIT
      else
        echo "Failed to publish ChatGPT's writable bundled-plugin resources" >&2
        exit 1
      fi
      exec {stagingWriterLockFd}>&-
    fi

    # Only lock-aware published caches can be removed safely.
    for obsoletePath in "$cacheRoot"/*; do
      if [[ "$obsoletePath" != "$resourcesPath" && -f "$obsoletePath/.complete" ]]; then
        obsoleteKey="''${obsoletePath##*/}"
        obsoleteLockPath="$cacheRoot/.locks/$obsoleteKey.lock"

        # Caches without a lock predate this protocol and may still be in use.
        if [[ -f "$obsoleteLockPath" ]]; then
          exec {obsoleteLockFd}> "$obsoleteLockPath"
          if flock --exclusive --nonblock "$obsoleteLockFd"; then
            if ! rm -rf -- "$obsoletePath"; then
              echo "Failed to remove obsolete ChatGPT bundled-plugin cache: $obsoletePath" >&2
            fi
          fi
          exec {obsoleteLockFd}>&-
        fi
      fi
    done

    export CODEX_ELECTRON_BUNDLED_PLUGINS_RESOURCES_PATH="$resourcesPath"

    waylandFlags=()
    if [[ -n "''${NIXOS_OZONE_WL:-}" && -n "''${WAYLAND_DISPLAY:-}" ]]; then
      waylandFlags=(
        --ozone-platform=wayland
        --enable-features=WaylandWindowDecorations
        --enable-wayland-ime=true
      )
    fi

    exec "$CHATGPT_EXECUTABLE" "''${waylandFlags[@]}" "$@"
  '';
}
