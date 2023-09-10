{ lib
, stdenv
, fetchurl
, dpkg
, python3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "howdy";
  version = "2.6.1";

  src = fetchurl {
    url = "https://github.com/boltgolt/howdy/releases/download/v${finalAttrs.version}/howdy_${finalAttrs.version}.deb";
    hash = "sha256-wQQynYx/VFCLMXrH+5eC6uQQQYe6xlfuioCu7rQGyE8=";
  };

  nativeBuildInputs = [ dpkg ];

  buildInputs = [ python3 ];

  postInstall = ''
    mkdir -p $out/bin
    mv -t $out lib usr/share

    patchShebangs $out/lib/security/howdy/cli.py
    ln -s $out/lib/security/howdy/cli.py $out/bin/howdy
  '';

  meta = with lib; {
    description = "Windows Hello™ style facial authentication for Linux";
    homepage = "https://github.com/boltgolt/howdy";
    license = licenses.mit;
    maintainers = with maintainers; [ kashw2 ];
    platforms = platforms.linux;
  };
})
