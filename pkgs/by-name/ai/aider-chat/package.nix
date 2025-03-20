{
  python3Packages,
  withPlaywright ? false,
}:

if withPlaywright then
  python3Packages.toPythonApplication python3Packages.aider-chat.passthru.withPlaywright
else
  python3Packages.toPythonApplication python3Packages.aider-chat
