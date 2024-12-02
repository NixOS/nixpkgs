{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, texinfo }:

stdenv.mkDerivation rec {
  pname = "macchanger";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "alobbs";
    repo = "macchanger";
    rev = version;
    sha256 = "1hypx6sxhd2b1nsxj314hpkhj7q4x9p2kfaaf20rjkkkig0nck9r";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/m/macchanger/1.7.0-5.3/debian/patches/02-fix_usage_message.patch";
      sha256 = "0pxljmq0l0znylbhms09i19qwil74gm8gx3xx2ffx00dajaizj18";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/m/macchanger/1.7.0-5.3/debian/patches/06-update_OUI_list.patch";
      sha256 = "04kbd784z9nwkjva5ckkvb0yb3pim9valb1viywn1yyh577d0y7w";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/m/macchanger/1.7.0-5.3/debian/patches/08-fix_random_MAC_choice.patch";
      sha256 = "1vz3appxxsdf1imzrn57amazfwlbrvx6g78b6n88aqgwzy5dm34d";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/m/macchanger/1.7.0-5.3/debian/patches/check-random-device-read-errors.patch";
      sha256 = "0pra6qnk39crjlidspg3l6hpaqiw43cypahx793l59mqn956cngc";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/m/macchanger/1.7.0-5.3/debian/patches/verify-changed-MAC.patch";
      sha256 = "0vjhf2fnj1hlghjl821p6idrfc8hmd4lgps5lf1l68ylqvwjw0zj";
    })
  ];

  nativeBuildInputs = [ autoreconfHook texinfo ];

  outputs = [ "out" "info" ];

  meta = with lib; {
    description = "Utility for viewing/manipulating the MAC address of network interfaces";
    maintainers = with maintainers; [ joachifm dotlambda ];
    license = licenses.gpl2Plus;
    homepage = "https://github.com/alobbs/macchanger";
    platforms = platforms.linux;
    mainProgram = "macchanger";
  };
}
