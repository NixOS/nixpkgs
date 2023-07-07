# opentoonz's source archive contains both opentoonz's source and a modified
# version of libtiff that opentoonz requires.

{ fetchFromGitHub, }: rec {
  versions = {
    opentoonz = "1.5.0";
    libtiff = "4.0.3";  # The version in thirdparty/tiff-*
  };

  src = fetchFromGitHub {
    owner = "opentoonz";
    repo = "opentoonz";
    rev = "v${versions.opentoonz}";
    sha256 = "1rw30ksw3zjph1cwxkfvqj0330v8wd4333gn0fdf3cln1w0549lk";
  };
}
