{ stdenv, callPackage, nodePackages, makeWrapper, libXScrnSaver,
  fetchFromGitHub, electron-packager, nodejs }:

let version = "1.5.4-beta-rolling";
    yakyakNpmDeps = nodePackages."yakyakNpmDeps-../../applications/networking/instant-messengers/yakyak";
    hangupsjs = nodePackages."hangupsjs-1.3.8".override(oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ nodePackages."coffee-script" ];
    });

in stdenv.mkDerivation rec {
  name = "yakyak";
  src = fetchFromGitHub {
    rev = "v${version}";
    repo = "yakyak";
    owner = "yakyak";
    sha256 = "1pvd4kh57hh0gg68drdlpqchxc38vzzn6kmnb4y4jja4q3xxlyv2";
  };

  dontPatchELF = true; # this prevents trace trap

  nativeBuildInputs = [ makeWrapper libXScrnSaver ];

  buildInputs = [ electron-packager nodejs ];

  buildPhase = ''
    ln -s ${yakyakNpmDeps}/lib/node_modules/yakyakNpmDeps/node_modules ./

    substituteInPlace ./gulpfile.coffee --replace ".pipe install(production:true)" ""

    npx gulp default
    npx gulp package

    # this must be copied while yakyakNpmDeps and hangupsjs are seperate
    mkdir -p ./app/node_modules
    cp -r ${yakyakNpmDeps}/lib/node_modules/yakyakNpmDeps/node_modules/* ./app/node_modules
    cp -r ${hangupsjs}/lib/node_modules/hangupsjs ./app/node_modules
    chmod -R +rw ./app/node_modules

    electron-packager ./app yakyak \
      --dir ./app \
      --out ./dist \
      --icon ./src/icons/icon \
      --prune false \
      --platform linux \
      --arch x64

    mkdir -p $out/lib/yakyak
    cp -r ./dist/yakyak-linux-x64/* $out/lib/yakyak

    wrapProgram $out/lib/yakyak/yakyak \
      --prefix LD_PRELOAD : ${stdenv.lib.makeLibraryPath [ libXScrnSaver ]}/libXss.so.1 \
      "''${gappsWrapperArgs[@]}"

    # make a desktop link
    mkdir -p $out/share/applications $out/share/pixmaps
    cp ./resources/linux/app.desktop $out/share/applications/YakYak.desktop
    cp ./src/icons/icon.png $out/share/pixmaps/yakyak.png
    substituteInPlace $out/share/applications/YakYak.desktop \
      --replace /opt/yakyak/yakyak $out/bin/yakyak \
      --replace Icon=yakyak Icon=$out/share/pixmaps/yakyak.png
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv $out/lib/yakyak/yakyak $out/bin/yakyak
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/yakyak/yakyak;
    description = "Desktop chat client for Google Hangouts";
    license = licenses.mit;
    maintainers = with maintainers; [ hlolli ];
    platforms = [ "x86_64-linux" ];
  };
}
