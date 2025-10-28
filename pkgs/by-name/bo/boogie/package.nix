{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  z3,
  dotnetCorePackages,
  nix-update-script,
}:

buildDotnetModule rec {
  pname = "Boogie";
  version = "3.5.5";

  src = fetchFromGitHub {
    owner = "boogie-org";
    repo = "boogie";
    tag = "v${version}";
    hash = "sha256-OuNzxzcoWrDCmUfQNXEif5wIY+L5jql14231m7nNBe4=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  projectFile = [ "Source/Boogie.sln" ];
  nugetDeps = ./deps.json;

  # [...]Microsoft.NET.Publish.targets(248,5): error MSB3021: Unable to copy file "[...]/NUnit3.TestAdapter.pdb" to "[...]/NUnit3.TestAdapter.pdb". Access to the path '[...]/NUnit3.TestAdapter.pdb' is denied. [[...]/ExecutionEngineTests.csproj]
  enableParallelBuilding = false;

  executables = [ "BoogieDriver" ];

  makeWrapperArgs = [
    "--prefix PATH : ${z3}/bin"
  ];

  postInstall = ''
    # so that this derivation can be used as a vim plugin to install syntax highlighting
    vimdir=$out/share/vim-plugins/boogie
    install -Dt $vimdir/syntax/ Util/vim/syntax/boogie.vim
    mkdir $vimdir/ftdetect
    echo 'au BufRead,BufNewFile *.bpl set filetype=boogie' > $vimdir/ftdetect/bpl.vim
    mkdir -p $out/share/nvim
    ln -s $out/share/vim-plugins/boogie $out/share/nvim/site
  '';

  postFixup = ''
    ln -s "$out/bin/BoogieDriver" "$out/bin/boogie"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/boogie ${./install-check-file.bpl}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Intermediate verification language";
    changelog = "https://github.com/boogie-org/boogie/releases/tag/${src.tag}";
    homepage = "https://github.com/boogie-org/boogie";
    longDescription = ''
      Boogie is an intermediate verification language (IVL), intended as a
      layer on which to build program verifiers for other languages.

      This derivation may be used as a vim plugin to provide syntax highlighting.
    '';
    license = lib.licenses.mspl;
    mainProgram = "boogie";
    maintainers = with lib.maintainers; [ taktoa ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
