{ lib }:
{
  nameShort = "Code - OSS";
  nameLong = "Code - OSS";
  applicationName = "code-oss";
  dataFolderName = ".vscode-oss";
  win32MutexName = "vscodeoss";
  licenseName = "MIT";
  licenseUrl = "https://github.com/microsoft/vscode/blob/main/LICENSE.txt";
  serverLicenseUrl = "https://github.com/microsoft/vscode/blob/main/LICENSE.txt";
  serverGreeting = [ ];
  serverLicense = [ ];
  serverLicensePrompt = "";
  serverApplicationName = "code-server-oss";
  serverDataFolderName = ".vscode-server-oss";
  tunnelApplicationName = "code-tunnel-oss";
  win32DirName = "Microsoft Code OSS";
  win32NameVersion = "Microsoft Code OSS";
  win32RegValueName = "CodeOSS";
  win32x64AppId = "{{D77B7E06-80BA-4137-BCF4-654B95CCEBC5}";
  win32arm64AppId = "{{D1ACE434-89C5-48D1-88D3-E2991DF85475}";
  win32x64UserAppId = "{{CC6B787D-37A0-49E8-AE24-8559A032BE0C}";
  win32arm64UserAppId = "{{3AEBF0C8-F733-4AD4-BADE-FDB816D53D7B}";
  win32AppUserModelId = "Microsoft.CodeOSS";
  win32ShellNameShort = "C&ode - OSS";
  win32TunnelServiceMutex = "vscodeoss-tunnelservice";
  win32TunnelMutex = "vscodeoss-tunnel";
  darwinBundleIdentifier = "com.visualstudio.code.oss";
  linuxIconName = "code-oss";
  licenseFileName = "LICENSE.txt";
  reportIssueUrl = "https://github.com/microsoft/vscode/issues/new";
  nodejsRepository = "https://nodejs.org";
  urlProtocol = "code-oss";
  webviewContentExternalBaseUrlTemplate = "https://{{uuid}}.vscode-cdn.net/insider/ef65ac1ba57f57f2a3961bfe94aa20481caca4c6/out/vs/workbench/contrib/webview/browser/pre/";

  extensionAllowedBadgeProviders = [
    "api.bintray.com"
    "api.travis-ci.com"
    "api.travis-ci.org"
    "app.fossa.io"
    "badge.buildkite.com"
    "badge.fury.io"
    "badge.waffle.io"
    "badgen.net"
    "badges.frapsoft.com"
    "badges.gitter.im"
    "badges.greenkeeper.io"
    "cdn.travis-ci.com"
    "cdn.travis-ci.org"
    "ci.appveyor.com"
    "circleci.com"
    "cla.opensource.microsoft.com"
    "codacy.com"
    "codeclimate.com"
    "codecov.io"
    "coveralls.io"
    "david-dm.org"
    "deepscan.io"
    "dev.azure.com"
    "docs.rs"
    "flat.badgen.net"
    "gemnasium.com"
    "githost.io"
    "gitlab.com"
    "godoc.org"
    "goreportcard.com"
    "img.shields.io"
    "isitmaintained.com"
    "marketplace.visualstudio.com"
    "nodesecurity.io"
    "opencollective.com"
    "snyk.io"
    "travis-ci.com"
    "travis-ci.org"
    "visualstudio.com"
    "vsmarketplacebadge.apphb.com"
    "www.bithound.io"
    "www.versioneye.com"
  ];
  extensionAllowedBadgeProvidersRegex = [
    "^https:\\/\\/github\\.com\\/[^/]+\\/[^/]+\\/(actions\\/)?workflows\\/.*badge\\.svg"
  ];
  extensionEnabledApiProposals = {
    "ms-vscode.vscode-selfhost-test-provider" = [ "testObserver" ];
    "VisualStudioExptTeam.vscodeintellicode-completions" = [ "inlineCompletionsAdditions" ];
    "ms-toolsai.datawrangler" = [ "debugFocus" ];
    "ms-vsliveshare.vsliveshare" = [
      "contribMenuBarHome"
      "contribShareMenu"
      "contribStatusBarItems"
      "diffCommand"
      "documentFiltersExclusive"
      "fileSearchProvider"
      "findTextInFiles"
      "notebookCellExecutionState"
      "notebookLiveShare"
      "terminalDimensions"
      "terminalDataWriteEvent"
      "textSearchProvider"
    ];
    "ms-vscode.js-debug" = [
      "portsAttributes"
      "findTextInFiles"
      "workspaceTrust"
      "tunnels"
    ];
    "ms-toolsai.vscode-ai-remote" = [ "resolvers" ];
    "ms-python.python" = [
      "contribEditorContentMenu"
      "quickPickSortByLabel"
      "portsAttributes"
      "testObserver"
      "quickPickItemTooltip"
      "terminalDataWriteEvent"
      "terminalExecuteCommandEvent"
      "contribIssueReporter"
      "terminalShellIntegration"
    ];
    "ms-dotnettools.dotnet-interactive-vscode" = [ "notebookMessaging" ];
    "GitHub.codespaces" = [
      "contribEditSessions"
      "contribMenuBarHome"
      "contribRemoteHelp"
      "contribViewsRemote"
      "resolvers"
      "tunnels"
      "terminalDataWriteEvent"
      "treeViewReveal"
      "notebookKernelSource"
    ];
    "ms-vscode.azure-repos" = [
      "extensionRuntime"
      "fileSearchProvider"
      "textSearchProvider"
    ];
    "ms-vscode.remote-repositories" = [
      "canonicalUriProvider"
      "contribEditSessions"
      "contribRemoteHelp"
      "contribMenuBarHome"
      "contribViewsRemote"
      "contribViewsWelcome"
      "contribShareMenu"
      "documentFiltersExclusive"
      "editSessionIdentityProvider"
      "extensionRuntime"
      "fileSearchProvider"
      "quickPickSortByLabel"
      "workspaceTrust"
      "shareProvider"
      "scmActionButton"
      "scmSelectedProvider"
      "scmValidation"
      "textSearchProvider"
      "timeline"
    ];
    "ms-vscode-remote.remote-wsl" = [
      "resolvers"
      "contribRemoteHelp"
      "contribViewsRemote"
      "telemetry"
    ];
    "ms-vscode-remote.remote-ssh" = [
      "resolvers"
      "tunnels"
      "terminalDataWriteEvent"
      "contribRemoteHelp"
      "contribViewsRemote"
      "telemetry"
    ];
    "ms-vscode.remote-server" = [
      "resolvers"
      "tunnels"
      "contribViewsWelcome"
    ];
    "ms-vscode.remote-explorer" = [
      "contribRemoteHelp"
      "contribViewsRemote"
      "extensionsAny"
    ];
    "ms-vscode-remote.remote-containers" = [
      "contribEditSessions"
      "resolvers"
      "portsAttributes"
      "tunnels"
      "workspaceTrust"
      "terminalDimensions"
      "contribRemoteHelp"
      "contribViewsRemote"
    ];
    "ms-vscode.js-debug-nightly" = [
      "portsAttributes"
      "findTextInFiles"
      "workspaceTrust"
      "tunnels"
    ];
    "ms-vscode.lsif-browser" = [ "documentFiltersExclusive" ];
    "ms-vscode.vscode-speech" = [ "speech" ];
    "GitHub.vscode-pull-request-github" = [
      "activeComment"
      "codiconDecoration"
      "codeActionRanges"
      "commentingRangeHint"
      "commentReactor"
      "commentThreadApplicability"
      "contribAccessibilityHelpContent"
      "contribCommentEditorActionsMenu"
      "contribCommentPeekContext"
      "contribCommentThreadAdditionalMenu"
      "contribCommentsViewThreadMenus"
      "contribEditorContentMenu"
      "contribShareMenu"
      "diffCommand"
      "fileComments"
      "quickDiffProvider"
      "shareProvider"
      "tabInputTextMerge"
      "tokenInformation"
      "treeViewMarkdownMessage"
    ];
    "GitHub.copilot" = [ "inlineCompletionsAdditions" ];
    "GitHub.copilot-nightly" = [ "inlineCompletionsAdditions" ];
    "GitHub.copilot-chat" = [
      "interactive"
      "terminalDataWriteEvent"
      "terminalExecuteCommandEvent"
      "terminalSelection"
      "terminalQuickFixProvider"
      "chatParticipant"
      "chatParticipantAdditions"
      "defaultChatParticipant"
      "chatVariableResolver"
      "chatProvider"
      "mappedEditsProvider"
      "aiRelatedInformation"
      "codeActionAI"
      "findTextInFiles"
      "textSearchProvider"
      "contribSourceControlInputBoxMenu"
      "newSymbolNamesProvider"
      "findFiles2"
      "extensionsAny"
      "authLearnMore"
      "testObserver"
    ];
    "GitHub.remotehub" = [
      "contribRemoteHelp"
      "contribMenuBarHome"
      "contribViewsRemote"
      "contribViewsWelcome"
      "documentFiltersExclusive"
      "extensionRuntime"
      "fileSearchProvider"
      "quickPickSortByLabel"
      "workspaceTrust"
      "scmSelectedProvider"
      "scmValidation"
      "textSearchProvider"
      "timeline"
    ];
    "ms-python.gather" = [ "notebookCellExecutionState" ];
    "ms-python.vscode-pylance" = [ "notebookCellExecutionState" ];
    "ms-python.debugpy" = [
      "portsAttributes"
      "contribIssueReporter"
      "debugVisualization"
    ];
    "ms-toolsai.jupyter-renderers" = [ "contribNotebookStaticPreloads" ];
    "ms-toolsai.jupyter" = [
      "notebookDeprecated"
      "notebookMessaging"
      "notebookMime"
      "notebookCellExecutionState"
      "portsAttributes"
      "quickPickSortByLabel"
      "notebookKernelSource"
      "interactiveWindow"
      "notebookControllerAffinityHidden"
      "contribNotebookStaticPreloads"
      "quickPickItemTooltip"
      "notebookExecution"
      "notebookCellExecution"
      "notebookVariableProvider"
    ];
    "dbaeumer.vscode-eslint" = [ "notebookCellExecutionState" ];
    "ms-vscode.azure-sphere-tools-ui" = [ "tunnels" ];
    "ms-azuretools.vscode-azureappservice" = [ "terminalDataWriteEvent" ];
    "ms-azuretools.vscode-azureresourcegroups" = [ "authGetSessions" ];
    "ms-vscode.anycode" = [ "extensionsAny" ];
    "ms-vscode.cpptools" = [ "terminalDataWriteEvent" ];
    "redhat.java" = [ "documentPaste" ];
    "ms-dotnettools.csdevkit" = [ "inlineCompletionsAdditions" ];
    "ms-dotnettools.vscodeintellicode-csharp" = [ "inlineCompletionsAdditions" ];
    "microsoft-IsvExpTools.powerplatform-vscode" = [
      "fileSearchProvider"
      "textSearchProvider"
    ];
    "microsoft-IsvExpTools.powerplatform-vscode-preview" = [
      "fileSearchProvider"
      "textSearchProvider"
    ];
    "apidev.azure-api-center" = [
      "chatParticipant"
      "languageModels"
    ];
    "jeanp413.open-remote-ssh" = [
      "resolvers"
      "tunnels"
      "terminalDataWriteEvent"
      "contribRemoteHelp"
      "contribViewsRemote"
    ];
    "jeanp413.open-remote-wsl" = [
      "resolvers"
      "contribRemoteHelp"
      "contribViewsRemote"
    ];
  };
  extensionKind = {
    "Shan.code-settings-sync" = [ "ui" ];
    "shalldie.background" = [ "ui" ];
    "techer.open-in-browser" = [ "ui" ];
    "CoenraadS.bracket-pair-colorizer-2" = [ "ui" ];
    "CoenraadS.bracket-pair-colorizer" = [
      "ui"
      "workspace"
    ];
    "hiro-sun.vscode-emacs" = [
      "ui"
      "workspace"
    ];
    "hnw.vscode-auto-open-markdown-preview" = [
      "ui"
      "workspace"
    ];
    "wayou.vscode-todo-highlight" = [
      "ui"
      "workspace"
    ];
    "aaron-bond.better-comments" = [
      "ui"
      "workspace"
    ];
    "vscodevim.vim" = [ "ui" ];
    "ollyhayes.colmak-vim" = [ "ui" ];
  };
  extensionPointExtensionKind = {
    typescriptServerPlugins = [ "workspace" ];
  };
  extensionSyncedKeys = {
    "ritwickdey.liveserver" = [ "liveServer.setup.version" ];
  };
  # Make a list of extensions with special virtual workspace defaults.
  extensionVirtualWorkspacesSupport =
    let
      defaultDefault = [
        "esbenp.prettier-vscode"
        "msjsdiag.debugger-for-chrome"
        "redhat.java"
        "HookyQR.beautify"
        "ritwickdey.LiveServer"
        "VisualStudioExptTeam.vscodeintellicode"
        "octref.vetur"
        "formulahendry.code-runner"
        "xdebug.php-debug"
        "ms-mssql.mssql"
        "christian-kohler.path-intellisense"
        "eg2.tslint"
        "eg2.vscode-npm-script"
        "donjayamanne.githistory"
        "Zignd.html-css-class-completion"
        "christian-kohler.npm-intellisense"
        "EditorConfig.EditorConfig"
        "austin.code-gnu-global"
        "johnpapa.Angular2"
        "ms-vscode.vscode-typescript-tslint-plugin"
        "DotJoshJohnson.xml"
        "techer.open-in-browser"
        "tht13.python"
        "bmewburn.vscode-intelephense-client"
        "Angular.ng-template"
        "xdebug.php-pack"
        "dbaeumer.jshint"
        "yzhang.markdown-all-in-one"
        "Dart-Code.flutter"
        "streetsidesoftware.code-spell-checker"
        "rebornix.Ruby"
        "ms-vscode.sublime-keybindings"
        "mitaki28.vscode-clang"
        "steoates.autoimport"
        "donjayamanne.python-extension-pack"
        "shd101wyy.markdown-preview-enhanced"
        "mikestead.dotenv"
        "pranaygp.vscode-css-peek"
        "ikappas.phpcs"
        "platformio.platformio-ide"
        "jchannon.csharpextensions"
        "gruntfuggly.todo-tree"
      ];
    in
    lib.genAttrs defaultDefault (name: {
      default = false;
    });

  builtInExtensions = [ ];

  # Commit, Version Info
}
