{ stdenv, lib, fetchFromGitHub, fetchpatch, fetchurl, cmake, xlibsWrapper
, ApplicationServices, Carbon, Cocoa, CoreServices, ScreenSaver, cf-private
, libX11, libXi, libXtst, libXrandr, xinput, curl, openssl, unzip }:

stdenv.mkDerivation rec {
  name = "synergy-${version}";
  version = "1.8.8";

  src = fetchFromGitHub {
    owner = "symless";
    repo = "synergy-core";
    rev = "v${version}-stable";
    sha256 = "0ksgr9hkf09h54572p7k7b9zkfhcdb2g2d5x7ixxn028y8i3jyp3";
  };

  patches = [./openssl-1.1.patch ./update_gtest_gmock.patch
  ] ++ lib.optional stdenv.isDarwin ./respect_macos_arch.patch;

  patch_gcc6 = fetchpatch {
    url = https://raw.githubusercontent.com/gentoo/gentoo/20e2bff3697ebf5f291e9907b34aae3074a36b53/dev-cpp/gmock/files/gmock-1.7.0-gcc6.patch;
    sha256 = "0j3f381x1lf8qci9pfv6mliggl8qs2w05v5lw3rs3gn7aibg174d";
  };

  # Due to the included gtest and gmock not supporting clang
  # we replace it with 1.7.0 for synergy-1.8.8. This should
  # become unnecessary when we update to a newer version of Synergy.
  gmock_zip = fetchurl {
    url = https://github.com/google/googlemock/archive/release-1.7.0.zip;
    sha256 = "11bd04098rzamv7f9y01zaf9c8zrmzdk6g1qrlwq780pxzlr4ya0";
  };

  gtest_zip = fetchurl {
    url = https://github.com/google/googletest/archive/release-1.7.0.zip;
    sha256 = "1l5n6kzdypjzjrz2jh14ylzrx735lccfx2p3s4ccgci8g9abg35m";
  };

  postPatch = ''
    ${unzip}/bin/unzip -d ext/ ${gmock_zip}
    ${unzip}/bin/unzip -d ext/ ${gtest_zip}
    mv ext/googlemock-release-1.7.0 ext/gmock-1.7.0
    mv ext/googletest-release-1.7.0 ext/gtest-1.7.0
    patch -d ext/gmock-1.7.0 -p1 -i ${patch_gcc6}
  ''
    # We have XRRNotifyEvent (libXrandr), but with the upstream CMakeLists.txt
    # it's not able to find it (it's trying to search the store path of libX11
    # instead) and we don't get XRandR support, even though the CMake output
    # _seems_ to say so:
    #
    #   Looking for XRRQueryExtension in Xrandr - found
    #
    # The relevant part however is:
    #
    #   Looking for XRRNotifyEvent - not found
    #
    # So let's force it:
  + lib.optionalString stdenv.isLinux ''
    sed -i -e '/HAVE_X11_EXTENSIONS_XRANDR_H/c \
      set(HAVE_X11_EXTENSIONS_XRANDR_H true)
    ' CMakeLists.txt
  '';

  cmakeFlags = lib.optionals stdenv.isDarwin [ "-DOSX_TARGET_MAJOR=10" "-DOSX_TARGET_MINOR=7" ];

  buildInputs = [
    cmake curl openssl
  ] ++ lib.optionals stdenv.isDarwin [
    ApplicationServices Carbon Cocoa CoreServices ScreenSaver cf-private
  ] ++ lib.optionals stdenv.isLinux [ xlibsWrapper libX11 libXi libXtst libXrandr xinput ];

  installPhase = ''
    mkdir -p $out/bin
    cp ../bin/synergyc $out/bin
    cp ../bin/synergys $out/bin
    cp ../bin/synergyd $out/bin
  '';

  doCheck = true;
  checkPhase = "../bin/unittests";

  meta = with lib; {
    description = "Share one mouse and keyboard between multiple computers";
    homepage = http://synergy-project.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ aszlig enzime ];
    platforms = platforms.all;
  };
}
