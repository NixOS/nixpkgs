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
    version = "2.6.8";

    src = fetchurl {
      url = "https://swupdate.openvpn.net/community/releases/openvpn-${version}.tar.gz";
      sha256 = "sha256-Xt4VZcim2IAQD38jUxen7p7qg9UFLbVUfxOp52r3gF0=";
    };

    nativeBuildInputs = oldAttrs.nativeBuildInputs or [ ] ++ [
      autoreconfHook
      pkg-config
    ];

    buildInputs = oldAttrs.buildInputs or [ ] ++ optional stdenv.hostPlatform.isLinux [ libnl.dev ];

    configureFlags = [
      # Assignment instead of appending to make sure to use exactly the flags required by mullvad

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
        commit = "6fb5e33345831e2bb1df884343893b67ecb83be3";
        sha256 = "sha256-MmYeFSw6c/QJh0LqLgkx+UxrbtTVv6zEFcnYEqznR1c=";
      })
      (fetchMullvadPatch {
        # "Send an event to any plugins when authentication fails"
        commit = "96d5bf40610927684ed5d13f8b512b63e8f764ef";
        sha256 = "sha256-HsVx0ZlK7VIFSFet4bG+UEG9W38tavNIP/udesH+Mmg=";
      })
      (fetchMullvadPatch {
        # "Shutdown when STDIN is closed"
        commit = "30708cefbd067928c896e3ef2420b22b82167ab8";
        sha256 = "sha256-apL5CWc470DvleQ/pjracsTL+v0zT00apj5cTHWPQZs=";
      })
      (fetchMullvadPatch {
        # "Undo dependency on Python docutils"
        commit = "debde9db82d8c2bd4857482c5242722eb1c08e6a";
        sha256 = "sha256-UKbQa3MDTJLKg0kZ47N7Gier3a6HP2yB6A551yqhWZU=";
      })
      (fetchMullvadPatch {
        # "Prevent signal when stdin is closed from being cleared (#10)"
        commit = "78812c51f3b2b6cb9efb73225e1002d055800889";
        sha256 = "sha256-XaAE90nMgS862NZ5PWcdWKa0YClxr4S24Nq1OVXezTc=";
      })
      (fetchMullvadPatch {
        # "Disable libcap-ng"
        commit = "ca3d25f2eff82b5fbfe1012ce900a961d35b35de";
        sha256 = "sha256-6bEUJ1FHXi1mzxkAaNdrMIHVrhewWenhRnW53rr2o6E=";
      })
      (fetchMullvadPatch {
        # "Remove libnsl dep"
        commit = "2d9821971fb29fff7243b49292a74eedb4036236";
        sha256 = "sha256-Eeci6U6go1ujmbVQvIVM/xa4GSambLPSaowVIvtYlzQ=";
      })
    ];
    postPatch = oldAttrs.postPatch or "" + ''
      rm ./configure
    '';

    meta = oldAttrs.meta or { } // {
      description = "OpenVPN with Mullvad-specific patches applied";
      homepage = "https://github.com/mullvad/openvpn";
      maintainers = with lib; [ maintainers.cole-h ];
    };
  }
)
