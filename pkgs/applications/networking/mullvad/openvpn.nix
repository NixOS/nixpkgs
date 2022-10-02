{ lib
, openvpn
, fetchpatch
, fetchurl
, iproute2
, autoconf
, automake
}:

openvpn.overrideAttrs (oldAttrs:
  let
    fetchMullvadPatch = { commit, sha256 }: fetchpatch {
      url = "https://github.com/mullvad/openvpn/commit/${commit}.patch";
      inherit sha256;
    };
  in
  rec {
    pname = "openvpn-mullvad";
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
    ];

    patches = oldAttrs.patches or [ ] ++ [
      # look at compare to find the relevant commits
      # https://github.com/OpenVPN/openvpn/compare/release/2.5...mullvad:mullvad-patches
      # used openvpn version is the latest tag ending with -mullvad
      # https://github.com/mullvad/openvpn/tags
      (fetchMullvadPatch {
        # "Reduce PUSH_REQUEST_INTERVAL to one second"
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

    meta = oldAttrs.meta or { } // {
      description = "OpenVPN with Mullvad-specific patches applied";
      homepage = "https://github.com/mullvad/openvpn";
      maintainers = with lib; [ maintainers.cole-h ];
    };
  })
