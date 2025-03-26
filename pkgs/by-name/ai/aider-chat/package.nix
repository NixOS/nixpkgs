{
  python3Packages,
  withPlaywright ? false,
  withBrowser ? false,
  withHelp ? false,
  withOptional ? false,
}:

if withPlaywright then
  python3Packages.toPythonApplication python3Packages.aider-chat.passthru.withPlaywright
else if withBrowser then
  python3Packages.toPythonApplication python3Packages.aider-chat.passthru.withBrowser
else if withHelp then
  python3Packages.toPythonApplication python3Packages.aider-chat.passthru.withHelp
else if withOptional then
  python3Packages.toPythonApplication python3Packages.aider-chat.passthru.withOptional
else
  python3Packages.toPythonApplication python3Packages.aider-chat
