{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  versionCheckHook,
}:

let
  pname = "marksman";
  dotnet-sdk = dotnetCorePackages.sdk_9_0_1xx-bin;
in
buildDotnetModule (finalAttrs: {
  inherit pname dotnet-sdk;
  version = "2025-11-30";

  src = fetchFromGitHub {
    owner = "artempyanykh";
    repo = "marksman";
    rev = finalAttrs.version;
    sha256 = "sha256-rEGMh4QsxTe35psbflYGgjjDDf0TzvItkx/ARE8ZC1E=";
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
    updateScript = ./update.sh;
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = with lib; {
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
    license = licenses.mit;
    maintainers = with maintainers; [
      stasjok
      plusgut
    ];
    platforms = dotnet-sdk.meta.platforms;
    mainProgram = pname;
  };
})
