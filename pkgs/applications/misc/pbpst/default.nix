{ llvmPackages, stdenv, fetchFromGitHub
, python36Packages, which, pkgconfig, curl, git, gettext, jansson

# Optional overrides
, maxFileSize ? 64 # in MB
, provider ? "https://ptpb.pw/"
}:

llvmPackages.stdenv.mkDerivation rec {
  version = "unstable-2018-01-11";
  name = "pbpst-${version}";

  src = fetchFromGitHub {
    owner = "HalosGhost";
    repo = "pbpst";
    rev = "ecbe08a0b72a6e4212f09fc6cf52a73506992346";
    sha256 = "0dwhmw1dg4hg75nlvk5kmvv3slz2n3b9x65q4ig16agwqfsp4mdm";
  };

  nativeBuildInputs = [
    python36Packages.sphinx
    which
    pkgconfig
    curl
    git
    gettext
  ];
  buildInputs = [ curl jansson ];

  patchPhase = ''
    patchShebangs ./configure

    # Remove hardcoded check for libs in /usr/lib/
    sed -e '64,67d' -i ./configure
  '';

  configureFlags = [
    "--file-max=${toString (maxFileSize * 1024 * 1024)}" # convert to bytes
    "--provider=${provider}"
  ];

  meta = with stdenv.lib; {
    description = "A command-line libcurl C client for pb deployments";
    inherit (src.meta) homepage;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tmplt ];
    broken = true;
  };
}
