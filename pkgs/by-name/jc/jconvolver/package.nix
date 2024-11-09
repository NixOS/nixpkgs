{ lib, stdenv, fetchurl, flac, unzip, fftwFloat, hybridreverb2, libclthreads, libjack2, libsndfile, zita-convolver }:

stdenv.mkDerivation rec {
  pname = "jconvolver";
  version = "1.1.0";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "03fq1rk5wyn32w0aaa9vqijnw9x9i0i7sv4nhsf949bk5lvi2nmc";
  };

  reverbs = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/jconvolver-reverbs.tar.bz2";
    sha256 = "127aj211xfqp37c94d9cn0mmwzbjkj3f6br5gr67ckqirvsdkndi";
  };
  weird = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/weird.wav";
    sha256 = "14xchdikx5k8zlgwglrqi168vki3n3rwhn73dkbj5qwh2ndrlyrc";
  };

  porihall-sf = fetchurl {
    url = "http://legacy.spa.aalto.fi/projects/poririrs/wavs/sndfld.zip";
    sha256 = "0z1kmdin3vcy6wmnym9jlfh8hwvci9404hff02cb98iw2slxid42";
  };
  porihall-bd = fetchurl {
    url = "http://legacy.spa.aalto.fi/projects/poririrs/wavs/bin_dfeq.zip";
    sha256 = "03m2brfxs851sag4z7kd71h6anv6hj34zcambwib0v1byg8vyplp";
  };
  porihall-c = fetchurl {
    url = "http://legacy.spa.aalto.fi/projects/poririrs/wavs/cardioid.zip";
    sha256 = "0ilbfvb2kvg5z6zi0mf2k4n0vgpir3iz5fa53xw92c07fs0cx36w";
  };

  spacenet-hm2 = fetchurl {
    url = "https://webfiles.york.ac.uk/OPENAIR/IRs/hamilton-mausoleum/b-format/hm2_000_bformat_48k.wav";
    sha256 = "1icnzfzq3mccbmnvmvh22mw8g8dci4i9h7lgrpmycj58v3gnb1p5";
  };
  spacenet-lyd3 = fetchurl {
    url = "https://webfiles.york.ac.uk/OPENAIR/IRs/st-andrews-church/b-format/lyd3_000_bformat_48k.wav";
    sha256 = "144cc0i91q5i72lwbxydx3nvxrd12j7clxjhwa2b8sf69ypz58wd";
  };
  spacenet-mh3 = fetchurl {
    url = "https://webfiles.york.ac.uk/OPENAIR/IRs/maes-howe/b-format/mh3_000_bformat_48k.wav";
    sha256 = "1c6v9jlm88l1sx2383yivycdrs9jqfsfx8cpbkjg19v2x1dfns0b";
  };
  spacenet-minster1 = fetchurl {
    url = "https://webfiles.york.ac.uk/OPENAIR/IRs/york-minster/b-format/minster1_bformat_48k.wav";
    sha256 = "1cs26pawjkv6qvwhfirfvzh21xvnmx8yh7f4xcr79cxv5c6hhnrw";
  };

  nativeBuildInputs = [ flac unzip ];

  buildInputs = [
    fftwFloat
    hybridreverb2
    libclthreads
    libjack2
    libsndfile
    zita-convolver
  ];

  outputs = [ "bin" "out" "doc" ];

  preConfigure = ''
    cd source
  '';

  makeFlags = [
    "PREFIX=$(bin)"
  ];

  postInstall = ''
    mkdir -p $doc/share/doc/jconvolver
    cp -r ../[A-Z]* $doc/share/doc/jconvolver/

    mkdir -p $out/share/jconvolver
    cp -r ../config-files $out/share/jconvolver/
    cd $out/share/jconvolver
    for conf in */*.conf */*/*.conf; do
      if grep -q /audio/ $conf; then
        substituteInPlace $conf --replace /audio/ $out/share/jconvolver/
      fi
    done
    substituteInPlace config-files/xtalk-cancel/EYCv2-44.conf --replace /cd "#/cd"
    ln -s ${weird} config-files/weird.wav

    tar xf ${reverbs}
    cd reverbs
    unzip -d porihall ${porihall-sf} s1_r4_sf.wav
    unzip -d porihall ${porihall-bd} s1_r3_bd.wav
    unzip -d porihall ${porihall-c} s1_r3_c.wav

    mkdir spacenet
    ln -s ${spacenet-hm2} spacenet/HM2_000_WXYZ_48k.amb
    ln -s ${spacenet-lyd3} spacenet/Lyd3_000_WXYZ_48k.amb
    ln -s ${spacenet-mh3} spacenet/MH3_000_WXYZ_48k.amb
    ln -s ${spacenet-minster1} spacenet/Minster1_000_WXYZ_48k.amb

    mkdir -p hybridreverb-database/large_concert_hall/music/8m
    for flac in ${hybridreverb2}/share/HybridReverb2/RIR_Database/large_concert_hall/music/8m/*.flac; do
      flac --output-prefix=hybridreverb-database/large_concert_hall/music/8m/ -d $flac
    done
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "JACK client and audio file convolver with reverb samples";
    homepage = "https://kokkinizita.linuxaudio.org/linuxaudio/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
