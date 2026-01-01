{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
<<<<<<< HEAD
  nix-update-script,
  versionCheckHook,
}:

let
  pname = "marksman";
  dotnet-sdk = dotnetCorePackages.sdk_9_0_1xx-bin;
in
buildDotnetModule (finalAttrs: {
  inherit pname dotnet-sdk;
  version = "2025-12-13";
=======
  marksman,
  testers,
}:

buildDotnetModule rec {
  pname = "marksman";
  version = "2024-12-18";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "artempyanykh";
    repo = "marksman";
<<<<<<< HEAD
    tag = finalAttrs.version;
    hash = "sha256-HgRovSdalRRG1Gx0vNYhRDTbYO/vpz4hB1pgqcVjWF4=";
  };

  projectFile = "Marksman/Marksman.fsproj";
  dotnetBuildFlags = [ "-p:VersionString=${finalAttrs.version}" ];
=======
    rev = version;
    sha256 = "sha256-2OisUZHmf7k8vLkBGJG1HXNxaXmRF64x//bDK57S9to=";
  };

  projectFile = "Marksman/Marksman.fsproj";
  dotnetBuildFlags = [ "-p:VersionString=${version}" ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  __darwinAllowLocalNetworking = true;

  doCheck = true;
  testProjectFile = "Tests/Tests.fsproj";

  nugetDeps = ./deps.json;

<<<<<<< HEAD
  dotnet-runtime = dotnetCorePackages.runtime_9_0;
=======
  dotnet-sdk = dotnetCorePackages.sdk_8_0_4xx-bin;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  postInstall = ''
    install -m 644 -D -t "$out/share/doc/${pname}" LICENSE
  '';

  passthru = {
<<<<<<< HEAD
    updateScript = nix-update-script { };
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
=======
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = marksman;
      command = "marksman --version";
    };
  };

  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      stasjok
      plusgut
    ];
    platforms = dotnet-sdk.meta.platforms;
<<<<<<< HEAD
    mainProgram = pname;
  };
})
=======
    mainProgram = "marksman";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
