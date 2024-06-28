# Define some common items among all vscode variants.
{
  lib,
  makeDesktopItem,
  executableName,
  longName,
  shortName,
}:
{
  desktopItem = makeDesktopItem {
    name = executableName;
    desktopName = longName;
    comment = "Code Editing. Redefined.";
    genericName = "Text Editor";
    exec = "${executableName} %F";
    icon = "vs${executableName}";
    startupNotify = true;
    startupWMClass = shortName;
    categories = [
      "Utility"
      "TextEditor"
      "Development"
      "IDE"
    ];
    mimeTypes = [
      "text/plain"
      "inode/directory"
    ];
    keywords = [ "vscode" ];
    actions.new-empty-window = {
      name = "New Empty Window";
      exec = "${executableName} --new-window %F";
      icon = "vs${executableName}";
    };
  };

  urlHandlerDesktopItem = makeDesktopItem {
    name = executableName + "-url-handler";
    desktopName = longName + " - URL Handler";
    comment = "Code Editing. Redefined.";
    genericName = "Text Editor";
    exec = executableName + " --open-url %U";
    icon = "vs${executableName}";
    startupNotify = true;
    categories = [
      "Utility"
      "TextEditor"
      "Development"
      "IDE"
    ];
    mimeTypes = [ "x-scheme-handler/vs${executableName}" ];
    keywords = [ "vscode" ];
    noDisplay = true;
  };

  meta = {
    description = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS
    '';
    longDescription = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS. It includes support for debugging, embedded Git
      control, syntax highlighting, intelligent code completion, snippets,
      and code refactoring. It is also customizable, so users can change the
      editor's theme, keyboard shortcuts, and preferences
    '';
    license = lib.licenses.mit;
    mainProgram = executableName;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
      "armv7l-linux"
    ];
  };
}
