# We don't have a wrapper which can supply obs-studio plugins so you have to
# somewhat manually install this:

# nix-env -f . -iA obs-linuxbrowser
# mkdir -p ~/.config/obs-studio/plugins
# ln -s ~/.nix-profile/share/obs/obs-plugins/obs-linuxbrowser ~/.config/obs-studio/plugins/

{ stdenv
, fetchFromGitHub
, cmake
, obs-studio
, libuiohook
}:

stdenv.mkDerivation rec {
  pname = "obs-input-overlay";
  version = "4.8";
  src = fetchFromGitHub {
    owner = "univrsal";
    repo = "input-overlay";
    rev = "v${version}";
    sha256 = "1dklg0dx9ijwyhgwcaqz859rbpaivmqxqvh9w3h4byrh5pnkz8bf";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio libuiohook ];

  patches = [ ./input-overlay-include-obs.patch ];

  cmakeFlags = [
    "-Wno-dev"
    "-DOBS_SRC_DIR=${obs-studio.src}"
  ];

  meta = with stdenv.lib; {
    description = "Show keyboard, gamepad and mouse input on stream ";
    homepage = "https://github.com/univrsal/input-overlay";
    maintainers = with maintainers; [ glittershark ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
