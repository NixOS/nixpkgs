{
  lib,
  stdenv,
  openvpn,
  fetchpatch,
  fetchurl,
  libnl,
  autoreconfHook,
  pkg-config,
}:

openvpn.overrideAttrs (
  oldAttrs:
  let
    inherit (lib) optional;
    fetchMullvadPatch =
      { commit, sha256 }:
      fetchpatch {
        url = "https://github.com/mullvad/openvpn/commit/${commit}.patch";
        inherit sha256;
      };
  in
  rec {
    pname = "openvpn-mullvad";
    version = "2.6.0";

    src = fetchurl {
      url = "https://swupdate.openvpn.net/community/releases/openvpn-${version}.tar.gz";
      sha256 = "sha256-6+yTMmPJhQ72984SXi8iIUvmCxy7jM/xiJJkP+CDro8=";
    };

    nativeBuildInputs = oldAttrs.nativeBuildInputs or [ ] ++ [
      autoreconfHook
      pkg-config
    ];

    buildInputs = oldAttrs.buildInputs or [ ] ++ optional stdenv.hostPlatform.isLinux [ libnl.dev ];

    configureFlags =
      [
        # Assignement instead of appending to make sure to use exactly the flags required by mullvad

        # Flags are based on https://github.com/mullvad/mullvadvpn-app-binaries/blob/main/Makefile#L17
        "--enable-static"
        "--disable-shared"
        "--disable-debug"
        "--disable-plugin-down-root"
        "--disable-management"
        "--disable-port-share"
        "--disable-systemd"
        "--disable-dependency-tracking"
        "--disable-pkcs11"
        "--disable-plugin-auth-pam"
        "--enable-plugins"
        "--disable-lzo"
        "--disable-lz4"
        "--enable-comp-stub"
      ]
      ++ optional stdenv.hostPlatform.isLinux [
        # Flags are based on https://github.com/mullvad/mullvadvpn-app-binaries/blob/main/Makefile#L35
        "--enable-dco" # requires libnl
        "--disable-iproute2"
      ];

    patches = oldAttrs.patches or [ ] ++ [
      # look at compare to find the relevant commits
      # https://github.com/OpenVPN/openvpn/compare/release/2.6...mullvad:mullvad-patches
      # used openvpn version is the latest tag ending with -mullvad
      # https://github.com/mullvad/openvpn/tags
      (fetchMullvadPatch {
        # "Reduce PUSH_REQUEST_INTERVAL to one second"
        commit = "4084b49de84e64c56584a378e85faf37973b6d6d";
        sha256 = "sha256-MmYeFSw6c/QJh0LqLgkx+UxrbtTVv6zEFcnYEqznR1c=";
      })
      (fetchMullvadPatch {
        # "Send an event to any plugins when authentication fails"
        commit = "f24de7922d70c6e1ae06acf18bce1f62d9fa6b07";
        sha256 = "sha256-RvlQbR6/s4NorYeA6FL7tE6geg6MIoZJtHeYxkVbdwA=";
      })
      (fetchMullvadPatch {
        # "Shutdown when STDIN is closed"
        commit = "81ae84271c044359b67991b15ebfb0cf9a32b3ad";
        sha256 = "sha256-ilKMyU97ha2m0p1FD64aNQncnKo4Tyi/nATuD5yPmVw=";
      })
      (fetchMullvadPatch {
        # "Undo dependency on Python docutils"
        commit = "a5064b4b6c598b68d8cabc3f4006e5addef1ec1e";
        sha256 = "sha256-+B6jxL0M+W5LzeukXkir26hn1OaYnycVNBwMYFq6gsE=";
      })
      (fetchMullvadPatch {
        # "Prevent signal when stdin is closed from being cleared (#10)"
        commit = "abe529e6d7f71228a036007c6c02624ec98ad6c1";
        sha256 = "sha256-qJQeEtZO/+8kenXTKv4Bx6NltUYe8AwzXQtJcyhrjfc=";
      })
      (fetchMullvadPatch {
        # "Disable libcap-ng"
        commit = "598014de7c063fa4e8ba1fffa01434229faafd04";
        sha256 = "sha256-+cFX5gmMuG6XFkTs6IV7utiKRF9E47F5Pgo93c+zBXo=";
      })
      (fetchMullvadPatch {
        # "Remove libnsl dep"
        commit = "845727e01ab3ec9bd58fcedb31b3cf2ebe2d5226";
        sha256 = "sha256-Via62wKVfMWHTmO7xIXXO7b5k0KYHs1D0JVg3qnXkeM=";
      })
    ];
    postPatch =
      oldAttrs.postPatch or ""
      + ''
        rm ./configure
      '';

    meta = oldAttrs.meta or { } // {
      description = "OpenVPN with Mullvad-specific patches applied";
      homepage = "https://github.com/mullvad/openvpn";
      maintainers = with lib; [ maintainers.cole-h ];
    };
  }
)
