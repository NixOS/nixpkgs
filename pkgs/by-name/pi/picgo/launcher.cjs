const { app } = require("electron");
const path = require("path");

// Set application name (determines config directory as ~/.config/picgo)
app.setName("picgo");

if (process.platform === "linux") {
  app.setDesktopName("picgo.desktop");
}

// Load main process
require(path.join(__dirname, "dist_electron/main/index.js"));
