{ stdenv, fetchFromGitHub, fetchNodeModules, nodejs-8_x, ruby, sencha
, auth0ClientID, auth0Domain }:

stdenv.mkDerivation rec {
  name = "rambox-bare-${version}";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "ramboxapp";
    repo = "community-edition";
    rev = version;
    sha256 = "1fsp4jxiypl6zkh5wgf9amyiyx9dqv6h8rsjn5xjp9bna27s0d3b";
  };

  nativeBuildInputs = [ nodejs-8_x ruby sencha ];

  node_modules = fetchNodeModules {
    inherit src;

    nodejs = nodejs-8_x;
    sha256 = "0qsgr8cq81yismal5sqr02skakqpynwwzk5s98dr5bg91y361fgy";
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
