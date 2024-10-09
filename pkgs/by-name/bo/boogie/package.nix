{ lib, buildDotnetModule, fetchFromGitHub, z3 }:

buildDotnetModule rec {
  pname = "Boogie";
  version = "3.2.4";

  src = fetchFromGitHub {
    owner = "boogie-org";
    repo = "boogie";
    rev = "v${version}";
    hash = "sha256-wpMENrhfD8+bt66gd29xkfLANcMbPpkzDacj0KPuXT4=";
  };

  projectFile = [ "Source/Boogie.sln" ];
  nugetDeps = ./deps.nix;

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
      rm -f $out/bin/{Microsoft,NUnit3,System}.* "$out/bin"/*Tests
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/boogie ${./install-check-file.bpl}
  '';

  meta = with lib; {
    description = "Intermediate verification language";
    homepage = "https://github.com/boogie-org/boogie";
    longDescription = ''
      Boogie is an intermediate verification language (IVL), intended as a
      layer on which to build program verifiers for other languages.

      This derivation may be used as a vim plugin to provide syntax highlighting.
    '';
    license = licenses.mspl;
    maintainers = [ maintainers.taktoa ];
    platforms = with platforms; (linux ++ darwin);
  };
}
