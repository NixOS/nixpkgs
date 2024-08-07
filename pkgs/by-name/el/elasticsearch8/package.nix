{ elk8Version
, lib
, stdenv
, fetchurl
, makeWrapper
, jre_headless
, util-linuxMinimal
, gnugrep
, coreutils
, autoPatchelfHook
, zlib
}:
with lib;
let
  util-linux = util-linuxMinimal;
  info = lib.splitString "-" stdenv.hostPlatform.system;
  arch = lib.elemAt info 0;
  plat = lib.elemAt info 1;
  hashes =
    {
      x86_64-linux   = "sha512-Me2f6eKLt3jBBC343EGDswROJQ1e5ddgxOXx/lyC5S4ogu0CgkxFSmT++6oQ+SEr3ptrT6onjiy13GS1eWDaAA==";
      x86_64-darwin  = "sha512-7U+jUn9T6nLDSkFYItqd28f5Y0ld1/sgvZetwPbJCpxjwj5oOfc8Qssrtp8KiiDQu+dtyGdofFydBj7l16uJJA==";
      aarch64-linux  = "sha512-qx7IeooPuzkjSwLT3ylxtDpW4gE59Trz5gvenL40rMDPQes/Ivk9qd6mQUan89UTQcgZ/chbs03OTMjjIinc5A==";
      aarch64-darwin = "sha512-s0buvjH6cH0oRecampyrdpDC5fBzT3i768qf3F+wanbmdapOXivxCxvgfFI1ug2coSXCM2cHubPuZ78VjMnfqA==";
    };

in
stdenv.mkDerivation rec {
  pname = "elasticsearch";
  version = elk8Version;

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/elasticsearch/${pname}-${version}-${plat}-${arch}.tar.gz";
    hash = hashes.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
  };

  patches = [ ./es-home-6.x.patch ./es-cli-8.x.patch ];

  postPatch = ''
    substituteInPlace bin/elasticsearch-cli --replace-fail \
      "LAUNCHER_CLASSPATH=\$ES_HOME/lib/*:\$ES_HOME/lib/cli-launcher/*" \
      "LAUNCHER_CLASSPATH=$out/lib/*:$out/lib/cli-launcher/*"
  '';

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) autoPatchelfHook;

  buildInputs = [ jre_headless util-linux zlib ];

  runtimeDependencies = [ zlib jre_headless ];

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib modules plugins $out

    chmod +x $out/bin/*

    substituteInPlace $out/bin/elasticsearch \
      --replace 'bin/elasticsearch-keystore' "$out/bin/elasticsearch-keystore"

    wrapProgram $out/bin/elasticsearch \
      --prefix PATH : "${makeBinPath [ util-linux coreutils gnugrep ]}" \
      --set ES_JAVA_HOME "${jre_headless}" \
      --set SCRIPT_NAME "$out/bin/elasticsearch"

    esbin=$out/bin/elasticsearch

    for file in $esbin-plugin $esbin-shard $esbin-node $esbin-reset-password; do
      wrapProgram $file --set ES_JAVA_HOME "${jre_headless}" \
        --set SCRIPT_NAME "$file"
    done
  '';

  passthru = { enableUnfree = true; };

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.elastic20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ apeschar basvandijk ];
  };
}
