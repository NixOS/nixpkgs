{ stdenv, fetchFromGitHub, octoprint, pythonPackages }:

let
  buildPlugin = args: pythonPackages.buildPythonPackage (args // {
    buildInputs = (args.buildInputs or []) ++ [ octoprint ];
  });
in {

  m3d-fio = buildPlugin rec {
    name = "M3D-Fio-${version}";
    version = "0.26";

    src = fetchFromGitHub {
      owner = "donovan6000";
      repo = "M3D-Fio";
      rev = "V${version}";
      sha256 = "1dl8m0cxp2vzla2a729r3jrq5ahxkj10pygp7m9bblj5nn2s0rll";
    };

    patches = [
      ./0001-Don-t-use-static-library.patch
      ./0002-Try-to-create-connection-several-times-if-printer-is.patch
    ];

    postInstall = ''
    (
      cd 'shared library source'
      make
      install -Dm755 libpreprocessor.so $out/lib/libpreprocessor.so
    )
    rm -rf $out/${pythonPackages.python.sitePackages}/octoprint_m3dfio/static/libraries
    '';

    meta = with stdenv.lib; {
      homepage = https://github.com/donovan6000/M3D-Fio;
      description = " OctoPrint plugin for the Micro 3D printer";
      platforms = platforms.all;
      license = licenses.gpl3;
      maintainers = with maintainers; [ abbradar ];
    };
  };

}
