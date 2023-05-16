{ lib
<<<<<<< HEAD
, stdenv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, openvpn
, fetchpatch
, fetchurl
, iproute2
<<<<<<< HEAD
, libnl
, autoreconfHook
, pkg-config
=======
, autoconf
, automake
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

openvpn.overrideAttrs (oldAttrs:
  let
<<<<<<< HEAD
    inherit (lib) optional;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchMullvadPatch = { commit, sha256 }: fetchpatch {
      url = "https://github.com/mullvad/openvpn/commit/${commit}.patch";
      inherit sha256;
    };
  in
  rec {
    pname = "openvpn-mullvad";
<<<<<<< HEAD
    version = "2.6.0";

    src = fetchurl {
      url = "https://swupdate.openvpn.net/community/releases/openvpn-${version}.tar.gz";
      sha256 = "sha256-6+yTMmPJhQ72984SXi8iIUvmCxy7jM/xiJJkP+CDro8=";
    };

    nativeBuildInputs = oldAttrs.nativeBuildInputs or [ ] ++ [
      autoreconfHook
      pkg-config
    ];

    buildInputs = oldAttrs.buildInputs or [ ]
       ++ optional stdenv.isLinux [ libnl.dev ];

    configureFlags = [
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
    ++ optional stdenv.isLinux [
      # Flags are based on https://github.com/mullvad/mullvadvpn-app-binaries/blob/main/Makefile#L35
      "--enable-dco" # requires libnl
      "--disable-iproute2"
=======
    version = "2.5.3";

    src = fetchurl {
      url = "https://swupdate.openvpn.net/community/releases/openvpn-${version}.tar.gz";
      sha256 = "sha256-dfAETfRJQwVVynuZWit3qyTylG/cNmgwG47cI5hqX34=";
    };

    buildInputs = oldAttrs.buildInputs or [ ] ++ [
      iproute2
    ];

    configureFlags = oldAttrs.configureFlags  or [ ] ++ [
      "--enable-iproute2"
      "IPROUTE=${iproute2}/sbin/ip"
    ];

    nativeBuildInputs = oldAttrs.nativeBuildInputs or [ ] ++ [
      autoconf
      automake
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ];

    patches = oldAttrs.patches or [ ] ++ [
      # look at compare to find the relevant commits
<<<<<<< HEAD
      # https://github.com/OpenVPN/openvpn/compare/release/2.6...mullvad:mullvad-patches
=======
      # https://github.com/OpenVPN/openvpn/compare/release/2.5...mullvad:mullvad-patches
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      # used openvpn version is the latest tag ending with -mullvad
      # https://github.com/mullvad/openvpn/tags
      (fetchMullvadPatch {
        # "Reduce PUSH_REQUEST_INTERVAL to one second"
<<<<<<< HEAD
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
    postPatch = oldAttrs.postPatch or "" + ''
      rm ./configure
    '';
=======
        commit = "41e44158fc71bb6cc8cc6edb6ada3307765a12e8";
        sha256 = "sha256-UoH0V6gTPdEuybFkWxdaB4zomt7rZeEUyXs9hVPbLb4=";
      })
      (fetchMullvadPatch {
        # "Allow auth plugins to set a failure reason"
        commit = "f51781c601e8c72ae107deaf25bf66f7c193e9cd";
        sha256 = "sha256-+kwG0YElL16T0e+avHlI8gNQdAxneRS6fylv7QXvC1s=";
      })
      (fetchMullvadPatch {
        # "Send an event to any plugins when authentication fails"
        commit = "c2f810f966f2ffd68564d940b5b8946ea6007d5a";
        sha256 = "sha256-PsKIxYwpLD66YaIpntXJM8OGcObyWBSAJsQ60ojvj30=";
      })
      (fetchMullvadPatch {
        # "Shutdown when STDIN is closed"
        commit = "879d6a3c0288b5443bbe1b94261655c329fc2e0e";
        sha256 = "sha256-pRFY4r+b91/xAKXx6u5GLzouQySXuO5gH0kMGm77a3c=";
      })
      (fetchMullvadPatch {
        # "Update TAP hardware ID"
        commit = "7f71b37a3b25bec0b33a0e29780c222aef869e9d";
        sha256 = "sha256-RF/GvD/ZvhLdt34wDdUT/yxa+IVWx0eY6WRdNWXxXeQ=";
      })
      (fetchMullvadPatch {
        # "Undo dependency on Python docutils"
        commit = "abd3c6214529d9f4143cc92dd874d8743abea17c";
        sha256 = "sha256-SC2RlpWHUDMAEKap1t60dC4hmalk3vok6xY+/xhC2U0=";
      })
      (fetchMullvadPatch {
        # "Prevent signal when stdin is closed from being cleared (#10)"
        commit = "b45b090c81e7b4f2dc938642af7a1e12f699f5c5";
        sha256 = "sha256-KPTFmbuJhMI+AvaRuu30CPPLQAXiE/VApxlUCqbZFls=";
      })
    ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    meta = oldAttrs.meta or { } // {
      description = "OpenVPN with Mullvad-specific patches applied";
      homepage = "https://github.com/mullvad/openvpn";
      maintainers = with lib; [ maintainers.cole-h ];
    };
  })
