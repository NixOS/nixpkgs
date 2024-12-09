{ lib, stdenv, fetchurl, pkg-config, lua, file, ncurses, gmime, pcre-cpp
, perl, perlPackages, makeWrapper
, debugBuild ? false
, alternativeGlobalConfigFilePath ? null
}:

let
  version    = "3.1";
  binaryName = if debugBuild then "lumail2-debug" else "lumail2";
  alternativeConfig = builtins.toFile "lumail2.lua"
    (builtins.readFile alternativeGlobalConfigFilePath);

  globalConfig = if alternativeGlobalConfigFilePath == null then ''
    mkdir -p $out/etc/lumail2
    cp global.config.lua $out/etc/lumail2.lua
    for n in ./lib/*.lua; do
      cp "$n" $out/etc/lumail2/
    done
  '' else ''
    ln -s ${alternativeConfig} $out/etc/lumail2.lua
  '';

  getPath  = type : "${lua}/lib/?.${type};";
  luaPath  = getPath "lua";
  luaCPath = getPath "so";
in
stdenv.mkDerivation {
  pname = "lumail";
  inherit version;

  src = fetchurl {
    url = "https://lumail.org/download/lumail-${version}.tar.gz";
    sha256 = "0vj7p7f02m3w8wb74ilajcwznc4ai4h2ikkz9ildy0c00aqsi5w4";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [
    lua file ncurses gmime pcre-cpp
    perl perlPackages.JSON perlPackages.NetIMAPClient
  ];

  preConfigure = ''
    sed -e 's|"/etc/lumail2|LUMAIL_LUAPATH"/..|' -i src/lumail2.cc src/imap_proxy.cc

    perlFlags=
    for i in $(IFS=:; echo $PERL5LIB); do
        perlFlags="$perlFlags -I$i"
    done

    sed -e "s|^#\!\(.*/perl.*\)$|#\!\1$perlFlags|" -i perl.d/imap-proxy
  '';

  buildFlags = lib.optional debugBuild "lumail2-debug";

  installPhase = ''
    mkdir -p $out/bin || true
    install -m755 ${binaryName} $out/bin/
  ''
  + globalConfig
  + ''
    wrapProgram $out/bin/${binaryName} \
        --prefix LUA_PATH : "${luaPath}" \
        --prefix LUA_CPATH : "${luaCPath}"
  '';

  makeFlags = [
    "LVER=lua"
    "PREFIX=$(out)"
    "SYSCONFDIR=$(out)/etc"
    "LUMAIL_LIBS=$(out)/etc/lumail2"
  ];

  meta = with lib; {
    description = "Console-based email client";
    mainProgram = "lumail2";
    homepage = "https://lumail.org/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [orivej];
  };
}
