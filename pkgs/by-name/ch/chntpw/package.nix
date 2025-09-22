{
  lib,
  stdenv,
  fetchurl,
  unzip,
  fetchDebianPatch,
}:

stdenv.mkDerivation rec {
  pname = "chntpw";

  version = "140201";

  src = fetchurl {
    url = "http://pogostick.net/~pnh/ntpasswd/chntpw-source-${version}.zip";
    sha256 = "1k1cxsj0221dpsqi5yibq2hr7n8xywnicl8yyaicn91y8h2hkqln";
  };

  nativeBuildInputs = [ unzip ];

  patches =
    let
      fetchChntpwDebianPatch =
        { patch, hash }:
        fetchDebianPatch {
          inherit
            hash
            patch
            pname
            version
            ;
          debianRevision = "1.2";
        };
    in
    [
      ./00-chntpw-build-arch-autodetect.patch
      ./01-chntpw-install-target.patch
      # Import various bug fixes from debian
      (fetchChntpwDebianPatch {
        patch = "04_get_abs_path";
        hash = "sha256-FuEEp/nZ3xNIpemcRTXPThxvQ7ZeB0REOqs0/Jl6AJ4=";
      })
      (fetchChntpwDebianPatch {
        patch = "06_correct_test_open_syscall";
        hash = "sha256-DQ55aRPM1uZOA6Q+C3ISJV0JayWFh2MRSnGuGtdAjwI=";
      })
      (fetchChntpwDebianPatch {
        patch = "07_detect_failure_to_write_key";
        hash = "sha256-lPDOY4ZKSZgLvfdPyurgGjvzzUCDU2JJ9/gKmK/tZl4=";
      })
      (fetchChntpwDebianPatch {
        patch = "08_no_deref_null";
        hash = "sha256-+gOoZuPwGp4byaNJ2dpb8kj6pohXDU1M1YIBqWR197w=";
      })
      (fetchChntpwDebianPatch {
        patch = "09_improve_robustness";
        hash = "sha256-SsX94ds80ccDe8pFAEbg8D4r4XK1cXZsVLbHAHybX9s=";
      })
      (fetchChntpwDebianPatch {
        patch = "11_improve_documentation";
        hash = "sha256-7+FXU7cMEAwtkoWnBRZnsN0Y75T66pyTwexgcSQ0FHs=";
      })
      (fetchChntpwDebianPatch {
        patch = "12_readonly_filesystem";
        hash = "sha256-RDly35sTVxuzEqH7ZXvh8fFC76B2oSfrw87QK9zxrM8=";
      })
      (fetchChntpwDebianPatch {
        patch = "13_write_to_hive";
        hash = "sha256-e2bM7TKyItJPaj3wyObuGQNve/QLCTvyqjNP2T2jaJg=";
      })
      (fetchChntpwDebianPatch {
        patch = "14_improve_description";
        hash = "sha256-OhexHr6rGTqM/XFJ0vS3prtI+RdcgjUtEfsT2AibxYc=";
      })
      (fetchChntpwDebianPatch {
        patch = "17_hexdump-pointer-type.patch";
        hash = "sha256-ir9LFl8FJq141OwF5SbyVMtjQ1kTMH1NXlHl0XZq7m8=";
      })
    ];

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = with lib; {
    homepage = "http://pogostick.net/~pnh/ntpasswd/";
    description = "Utility to reset the password of any user that has a valid local account on a Windows system";
    maintainers = with lib.maintainers; [ deepfire ];
    license = licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
}
