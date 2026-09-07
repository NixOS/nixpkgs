const { app, BrowserWindow } = require('electron');

app.setName(process.env.ELECTRON_APP_NAME || 'Antimatter Dimensions');

app.whenReady().then(() => {
  const mainWindow = new BrowserWindow({
    autoHideMenuBar: true,
  });
  mainWindow.loadFile('index.html');
});

app.on('window-all-closed', () => {
  app.quit();
});
