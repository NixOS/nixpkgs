{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  libuuid,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "biblesync";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "karlkleinpaste";
    repo = "biblesync";
    tag = finalAttrs.version;
    sha256 = "sha256-8CPP0ndrnJrGhNR7Y3lX3td5jXNE8VuwEiD8C2D4K5I=";
  };

  # `bind` is pulled from std::bind because of `using namespace std;`, so we
  # pin that here.
  # On Darwin, uuid/uuid.h and uuid_generate() are provided by the system
  # (libSystem). The bundled FindUUID.cmake would otherwise locate uuid/uuid.h
  # in the Apple SDK and add the SDK's include root as a plain -I path, which
  # breaks libc++'s header search order. Skip the lookup entirely.
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/biblesync.cc \
      --replace-fail "if (bind(server_fd" "if (::bind(server_fd"
    substituteInPlace CMakeLists.txt \
      --replace-fail 'FIND_PACKAGE(UUID REQUIRED)' "" \
      --replace-fail 'INCLUDE_DIRECTORIES("''${UUID_INCLUDE_DIRS}")' "" \
      --replace-fail 'TARGET_LINK_LIBRARIES(biblesync "''${UUID_LIBRARIES}")' ""
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs =
    lib.optional (!stdenv.hostPlatform.isDarwin) libuuid
    ++ lib.optional (stdenv.hostPlatform.isWindows || stdenv.hostPlatform.isDarwin) gettext;

  meta = {
    homepage = "https://wiki.crosswire.org/BibleSync";
    description = "Multicast protocol to Bible software shared conavigation";
    longDescription = ''
      BibleSync is a multicast protocol to support Bible software shared
      co-navigation. It uses LAN multicast in either a personal/small team
      mutual navigation motif or in a classroom environment where there are
      Speakers plus the Audience. The library implementing the protocol is a
      single C++ class providing a complete yet minimal public interface to
      support mode setting, setup for packet reception, transmit on local
      navigation, and handling of incoming packets.
    '';
    license = lib.licenses.publicDomain;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
