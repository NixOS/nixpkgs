{ stdenvNoCC, fetchFromGitHub, python3, lib
, flags ? {} ,whitelist ? ""}:

stdenvNoCC.mkDerivation rec {
  pname = "StevenBlack-hosts";
  version = "2.5.52";
  src = fetchFromGitHub {
    owner = "StevenBlack";
    repo = "hosts";
    rev = version;
    sha256 ="zQMzXci1/21PCvi8AGqyDataQl/kQJJ+jszxXd2XMQc=";
  };

  inherit whitelist;
  passAsFile = ["whitelist"];
  buildPhase =
    let 
      py = python3.withPackages (ps: with ps;[
        lxml beautifulsoup4
      ]);
    in ''
      ln -s $whitelistPath whitelist
      ${py}/bin/python updateHostsFile.py \
        ${lib.cli.toGNUCommandLineShell 
          {} (flags // {
            auto = true;
            noupdate = true;
            out = ".";
          })
        }
    '';
  
  installPhase = ''
    cp hosts $out
  '';
  
  meta = with lib;{
    homepage = "https://github.com/StevenBlack/hosts";
    description = "Extending and consolidating hosts files from several well-curated sources";
    license = licenses.unfreeRedistributable;
    platforms = platforms.all;
  };
}
