{ lib
, stdenv
, fetchurl
, cmake
, libsodium
, ncurses
, libopus
, libvpx
, check
, libconfig
, pkg-config
}:

let buildToxAV = !stdenv.isAarch32;
in stdenv.mkDerivation rec {
  pname = "libtoxcore";
  version = "0.2.19";

  src =
    # We need the prepared sources tarball.
    fetchurl {
      url =
        "https://github.com/TokTok/c-toxcore/releases/download/v${version}/c-toxcore-${version}.tar.gz";
      hash = "sha256-i0GPZHDbCFz1mpkVaFYTVWVW3yv0JxSPGBS3sRhihZQ=";
    };

  cmakeFlags = [
    "-DDHT_BOOTSTRAP=ON"
    "-DBOOTSTRAP_DAEMON=ON"
  ] ++ lib.optional buildToxAV "-DMUST_BUILD_TOXAV=ON";

  buildInputs = [
    libsodium
    ncurses
    libconfig
  ] ++ lib.optionals buildToxAV [
    libopus
    libvpx
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  doCheck = true;
  nativeCheckInputs = [ check ];

  postInstall = ''
    substituteInPlace $out/lib/pkgconfig/toxcore.pc \
      --replace '=''${prefix}/' '=' \

  '';
  # We might be getting the wrong pkg-config file anyway:
  # https://github.com/TokTok/c-toxcore/issues/2334

  meta = {
    description = "P2P FOSS instant messaging application aimed to replace Skype";
    homepage = "https://tox.chat";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ peterhoeg ehmry ];
    platforms = lib.platforms.all;
  };
}
