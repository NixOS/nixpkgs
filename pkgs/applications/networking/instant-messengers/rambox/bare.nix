{ stdenv, fetchFromGitHub, fetchNodeModules, nodejs-8_x, ruby, sencha
, auth0ClientID, auth0Domain }:

stdenv.mkDerivation rec {
  name = "rambox-bare-${version}";
  version = "0.5.17";

  src = fetchFromGitHub {
    owner = "saenzramiro";
    repo = "rambox";
    rev = version;
    sha256 = "18adga0symhb825db80l4c7kjl3lzzh54p1qibqsfa087rjxx9ay";
  };

  nativeBuildInputs = [ nodejs-8_x ruby sencha ];

  node_modules = fetchNodeModules {
    inherit src;

    nodejs = nodejs-8_x;
    sha256 = "1v7zwp8vs2pgy04qi92lvnxgfwkyxbid04lab8925wg1pvm2pk3k";
  };

  patches = [ ./isDev.patch ];

  configurePhase = ''
    echo 'var auth0Cfg = { clientID: "${auth0ClientID}", domain: "${auth0Domain}" };' > env.js
    ln -s ${node_modules} node_modules
  '';

  buildPhase = ''
    mkdir ../rambox-build
    npm run sencha:compile:build
  '';

  installPhase = ''
    mv ../rambox-build/ $out

    # https://github.com/saenzramiro/rambox/issues/1281
    echo '{"name": "rambox", "version": "${version}", "main": "electron/main.js"}' > $out/package.json

    # https://github.com/saenzramiro/rambox/issues/1282
    cp --parents ext/packages/ext-locale/build/ext-locale-*.js $out

    # Symbolic link causes `Uncaught Error: Cannot find module 'immutable'`
    cp -r ${node_modules} $out/node_modules
  '';

  meta = with stdenv.lib; {
    description = "Messaging and emailing app that combines common web applications into one";
    homepage = http://rambox.pro;
    license = licenses.gpl3;
    maintainers = with maintainers; [ gnidorah ];
    platforms = platforms.linux;
  };
}
