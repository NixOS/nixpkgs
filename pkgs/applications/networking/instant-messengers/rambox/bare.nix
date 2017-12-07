{ stdenv, fetchFromGitHub, fetchNodeModules, nodejs-8_x, ruby, sencha }:

stdenv.mkDerivation rec {
  name = "rambox-bare-${version}";
  version = "0.5.13";

  src = fetchFromGitHub {
    owner = "saenzramiro";
    repo = "rambox";
    rev = version;
    sha256 = "0c770a9z017y6gcrpyri7s1gifm8zi5f29bq5nvh3zzg4wgqh326";
  };

  nativeBuildInputs = [ nodejs-8_x ruby sencha ];

  node_modules = fetchNodeModules {
    inherit src;

    nodejs = nodejs-8_x;
    sha256 = "1y3q8ggyvfywxqi5hn9mvr1sjfylspis43iyf4b7snyr1a1br3r4";
  };

  patches = [ ./hide-check-for-updates.patch ./isDev.patch ];

  # These credentials are only for this derivation. If you want to get credentials
  # for another distribution, go to https://auth0.com. If you want to reuse the same
  # domain, drop a line at yegortimoshenko@gmail.com!
  auth0ClientID = "0spuNKfIGeLAQ_Iki9t3fGxbfJl3k8SU";
  auth0Domain = "nixpkgs.auth0.com";

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
