{ stdenvNoCC, fetchFromGitHub, python3, lib
, flags ? {} ,allowList ? ""}:

stdenvNoCC.mkDerivation rec {
  pname = "StevenBlack-hosts";
  version = "2.5.52";
  src = fetchFromGitHub {
    owner = "StevenBlack";
    repo = "hosts";
    rev = version;
    sha256 ="01 rijzfmvwfcirz94h74bx15maqdn9m01g7q197nvzxmr1fk60yd";
  };

  inherit allowList;
  passAsFile = ["allowList"];
  buildPhase =
    let
      py = python3.withPackages (ps: with ps;[
        lxml beautifulsoup4
      ]);
    in ''
      ln -s $allowListPath whitelist
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
    odir=$out/share/StevenBlack-hosts
    mkdir -p $odir
    cp {.,$odir}/hosts
  '';

  meta = with lib;{
    homepage = "https://github.com/StevenBlack/hosts";
    description = "Extending and consolidating hosts files from several well-curated sources";
    # While the python script may be MIT
    # the various sources are under various licenses
    # not all host sources are under free licenses,let alone permissive one
    # https://github.com/StevenBlack/hosts#sources-of-hosts-data-unified-in-this-variant
    license = licenses.unfreeRedistributable;
    platforms = platforms.all;
    mantainers = [ mantainers.pasqui23 ];
  };
}
