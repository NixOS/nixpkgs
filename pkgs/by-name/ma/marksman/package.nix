{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  nix-update-script,
  versionCheckHook,
}:

let
  pname = "marksman";
  dotnet-sdk = dotnetCorePackages.sdk_9_0_1xx-bin;
in
buildDotnetModule (finalAttrs: {
  inherit pname dotnet-sdk;
  version = "2026-02-08";

  src = fetchFromGitHub {
    owner = "artempyanykh";
    repo = "marksman";
    tag = finalAttrs.version;
    hash = "sha256-xebt55WKHOKwA6QIkW5mnvqUGHeGRzINCWfViA4cfJ0=";
  };

  projectFile = "Marksman/Marksman.fsproj";
  dotnetBuildFlags = [ "-p:VersionString=${finalAttrs.version}" ];

  __darwinAllowLocalNetworking = true;

  doCheck = true;
  testProjectFile = "Tests/Tests.fsproj";

  nugetDeps = ./deps.json;

  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  postInstall = ''
    install -m 644 -D -t "$out/share/doc/${pname}" LICENSE
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Language Server for Markdown";
    longDescription = ''
      Marksman is a program that integrates with your editor
      to assist you in writing and maintaining your Markdown documents.
      Using LSP protocol it provides completion, goto definition,
      find references, rename refactoring, diagnostics, and more.
      In addition to regular Markdown, it also supports wiki-link-style
      references that enable Zettelkasten-like note taking.
    '';
    homepage = "https://github.com/artempyanykh/marksman";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      stasjok
      plusgut
    ];
    platforms = dotnet-sdk.meta.platforms;
    mainProgram = "marksman";
  };
})
