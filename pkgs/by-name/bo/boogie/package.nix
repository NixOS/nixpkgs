{ lib, buildDotnetModule, fetchFromGitHub, z3 }:

buildDotnetModule rec {
  pname = "Boogie";
  version = "2.15.7";

  src = fetchFromGitHub {
    owner = "boogie-org";
    repo = "boogie";
    rev = "v${version}";
    sha256 = "16kdvkbx2zwj7m43cra12vhczbpj23wyrdnj0ygxf7np7c2aassp";
  };

  projectFile = [ "Source/Boogie.sln" ];
  nugetDeps = ./deps.nix;

  postInstall = ''
      mkdir -pv "$out/lib/dotnet/${pname}"
      ln -sv "${z3}/bin/z3" "$out/lib/dotnet/${pname}/z3.exe"

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

  meta = with lib; {
    description = "An intermediate verification language";
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

