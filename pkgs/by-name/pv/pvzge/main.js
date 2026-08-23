const { app, BrowserWindow } = require('electron/main')

function createWindow() {
  const win = new BrowserWindow({
    useContentSize: true,
    width: 975,
    height: 608,
    minWidth: 515,
    minHeight: 304,
    webPreferences: {
      nodeIntegration: true,
      enableRemoteModule: true,
      contextIsolation: false,
    },
  });
  win.loadFile('index.html');
  win.removeMenu();
}

app.whenReady().then(() => {
  createWindow();
  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  })
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
