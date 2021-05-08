{ stdenv, lib, fetchurl, dpkg, makeWrapper, buildFHSUserEnvBubblewrap }:

with lib;

let
  pkg = stdenv.mkDerivation rec {
    pname = "picoscope";
    # Make sure to update the dependencies to the correct versions when
    # updating here!
    version = "6.14.44-4r5870";

    srcs = let base = "https://labs.picotech.com/debian/pool/main";
    in [
      (fetchurl {
        url = "${base}/p/picoscope/${pname}_${version}_all.deb";
        sha256 = "05ryzchk6xwcv6cssik05mxhi7bp8i7szc05gjrff60bnaygx324";
      })
      (fetchurl {
        url = "${base}/libp/libpicoipp/libpicoipp_1.3.0-4r78_amd64.deb";
        sha256 = "0qd7kdiw3dxfrnd9hyxab3bb3sahyrn0pqnv0x6ca7sg47955h67";
      })
      (fetchurl {
        url = "${base}/libu/libusbdrdaq/libusbdrdaq_2.0.61-1r2597_amd64.deb";
        sha256 = "1qacqzg8mh6f3pbjnkzdq1ffj9wbmgykf75x29vd9cbdhxpxpfj4";
      })
      (fetchurl {
        url = "${base}/p/picomono/picomono_4.6.2.16-1r02_amd64.deb";
        sha256 = "0cq4pfpsx2kfqn5x4v66zc7q5czcp4r5lm4mwgbfhzkj9rz93brb";
      })
      (fetchurl {
        url = "${base}/libp/libpl1000/libpl1000_2.0.61-1r2597_amd64.deb";
        sha256 = "1b4h6wl5kan5vrwgn88mrhiimb5r2hly8a1f3j1cz9r9c68vpdy6";
      })
      (fetchurl {
        url = "${base}/libp/libps2000/libps2000_3.0.63-3r2621_amd64.deb";
        sha256 = "1b2mj9825h7mvq12mxpqxga1j5bksgn3dq46cc2wrn2kgyhgfjlv";
      })
      (fetchurl {
        url = "${base}/libp/libps2000a/libps2000a_2.1.61-5r2597_amd64.deb";
        sha256 = "12ggs2j29av33pgyclr87fd28yig35rrk730x0wl82ik0inbzv6g";
      })
      (fetchurl {
        url = "${base}/libp/libps3000/libps3000_4.0.63-3r2621_amd64.deb";
        sha256 = "0pnq4igblvcilgmfk5sja3hmh1rbdia4sjcg267wg59y8rrbhlkh";
      })
      (fetchurl {
        url = "${base}/libp/libps3000a/libps3000a_2.1.61-6r2597_amd64.deb";
        sha256 = "03dvvw0bj0p1mgf89g6f589ff6c8aq9m3ff53mz8nshwfdv4iipv";
      })
      (fetchurl {
        url = "${base}/libp/libps4000/libps4000_2.1.61-2r2597_amd64.deb";
        sha256 = "1hc3nd2wvlrhvcbilm0r7alwh72fjhgnxwym27pp7zyj0ng2kk44";
      })
      (fetchurl {
        url = "${base}/libp/libps4000a/libps4000a_2.1.61-2r2597_amd64.deb";
        sha256 = "0c7fziq09vk4r6gn8hpl8p6fpvbqbprlv34ibx1pdvkx81adcf8q";
      })
      (fetchurl {
        url = "${base}/libp/libps5000/libps5000_2.1.61-3r2597_amd64.deb";
        sha256 = "12nhjpn10ap193kzmndb5lsgfzzwh674p0igla9qxncgy0kxcazd";
      })
      (fetchurl {
        url = "${base}/libp/libps5000a/libps5000a_2.1.61-5r2597_amd64.deb";
        sha256 = "0pkccacn81mkn200igy1441mxrknzr3yi1m8ggsrhw41qyxjizbq";
      })
      (fetchurl {
        url = "${base}/libp/libps6000/libps6000_2.1.61-6r2597_amd64.deb";
        sha256 = "1bk67w8plxbp9czpsws2kzcysymw2j18467nvss7p0qvcqawy1dv";
      })
      (fetchurl {
        url = "${base}/libp/libps6000a/libps6000a_1.0.61-0r2608_amd64.deb";
        sha256 = "1ircb3ilqavm4xbpnw1ic23k1ynqi1yzy5cyf8rnhbqcwckiglsg";
      })
    ];

    nativeBuildInputs = [ dpkg makeWrapper ];

    dontConfigure = true;
    dontBuild = true;

    unpackPhase = ''
      for source in ${toString srcs}; do
        echo "unpacking $source"
        dpkg-deb -x $source .
      done
    '';

    installPhase = ''
      mkdir -p "$out"
      mv etc opt usr "$out"

      mkdir -p "$out/bin"
      makeWrapper "$out/opt/picomono/bin/mono" "$out/bin/picoscope" \
        --add-flags "$out/opt/picoscope/lib/PicoScope.GTK.exe" \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [ "$out/opt/picoscope" ]
        }
    '';

    meta = with lib; {
      description = "Oscilloscope application that works with all PicoScope models";
      longDescription = ''
        PicoScope for Linux is a powerful oscilloscope application that works
        with all PicoScope models. The most important features from PicoScope
        for Windows are included—scope, spectrum analyzer, advanced triggers,
        automated measurements, interactive zoom, persistence modes and signal
        generator control. More features are being added all the time.

        Waveform captures can be saved for off-line analysis, and shared with
        PicoScope for Linux, PicoScope for macOS and PicoScope for Windows
        users, or exported in text, CSV and MathWorks MATLAB 4 formats.
      '';
      homepage = "https://www.picotech.com/downloads/linux";
      license = licenses.unfree;
      platforms = platforms.linux;
      maintainers = with maintainers; [ expipiplus1 wirew0rm ];
    };
  }

  ;

in buildFHSUserEnvBubblewrap {
  name = "picoscope";
  targetPkgs = pkgs:
    (with pkgs; [ pkg glib gtk2 libusb1 gtk-sharp-2_0 libpng12 ]);
  runScript = "${pkg}/bin/${pkg.pname}";
  extraBuildCommands = ''
    ln -s ${pkg}/opt
  '';
}

