{ stdenv, fetchFromGitHub, fetchpatch
, SDL2, SDL2_image
, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "klystrack";
  version = "1.7.6";

  src = fetchFromGitHub {
    owner = "kometbomb";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "1h99sm2ddaq483hhk2s3z4bjbgn0d2h7qna7l7qq98wvhqix8iyz";
  };

  buildInputs = [
    SDL2 SDL2_image
  ];
  nativeBuildInputs = [ pkgconfig ];

  patches = [
    (fetchpatch {
      url = "https://github.com/kometbomb/klystrack/commit/bb537595d02140176831c4a1b8e9121978b32d22.patch";
      sha256 = "06gl9q0jwg039kpxb13lg9x0k59s11968qn4lybgkadvzmhxkgmi";
    })
  ];

  buildFlags = [ "PREFIX=${placeholder "out"}" "CFG=release" ];

  installPhase = ''
    install -Dm755 bin.release/klystrack $out/bin/klystrack

    mkdir -p $out/lib/klystrack
    cp -R res $out/lib/klystrack
    cp -R key $out/lib/klystrack

    install -DT icon/256x256.png $out/share/icons/hicolor/256x256/apps/klystrack.png
    mkdir -p $out/share/applications
    substitute linux/klystrack.desktop $out/share/applications/klystrack.desktop \
      --replace "klystrack %f" "$out/bin/klystrack %f"
  '';

  meta = with stdenv.lib; {
    description = "A chiptune tracker";
    homepage = "https://kometbomb.github.io/klystrack";
    license = licenses.mit;
    maintainers = with maintainers; [ suhr ];
    platforms = platforms.linux;
  };
}
