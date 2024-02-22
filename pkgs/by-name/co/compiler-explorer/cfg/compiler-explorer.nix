{ lib
, writeText
, utils
, defaultGcc
, cmake
, coreutils
, python3Full
}:
let
  settings =
    {
      timeouts = {
        compileTimeoutMs = 20000;
        binaryExecTimeoutMs = 10000;
        compilationEnvTimeoutMs = 300000;
        compilationStaleAfterMs = 100000;
      };

      cache =
        {
          cacheConfig = "InMemory(50)";
          executableCacheConfig = "InMemory(50)";
          compilerCacheConfig = "OnDisk(/tmp/compiler-explorer-cache,1024)";
        };

      storage =
        {
          storageSolution = "local";
          localStorageFolder = "/tmp/compiler-explorer-storage/";
        };


      tools =
        {
          python3 = "${lib.getExe python3Full}";
          cmake = "${cmake}/bin/cmake";
          useninja = "false";
          ld = "${defaultGcc}/bin/ld";
          readElf = "${defaultGcc}/bin/readelf";
          mkfido = "${coreutils}/bin/mkfifo";
          headptrackPath = "";
          ldPath = "\${exePath}/../lib|\${exePath}/../lib32|\${exePath}/../lib64";
          demanglerType = "default";
          objdumperType = "default";
          cvCompilerCountMax = 15;
          ceToolsPath = "../compiler-explorer-tools";
        };

      misc =
        {
          defaultSource = "builtin";
          apiMaxAgeSecs = 600;
          maxConcurrentCompiles = 4;
          staticMaxAgeSecs = 1;
          maxUploadSize = "16mb";
          supportsExecute = "true";
          optionsAllowedRe = ".*";

          delayCleanup = "false";
          thirdPartyIntegrationEnabled = "true";
          statusTrackingEnabled = "false";
          showSponsors = "false";
          textBanner = "Compiler Explorer for NIX";
        };

      privacy = {
        cookiePolicyEnabled = "false";
        privacyPolicyEnabled = "false";
      };

      remote = {
        allowedShortUrlHostRe = "^([-a-z.]+\.)?(xania|godbolt)\.org$";
        googleShortLinkRewrite = "^https?://goo.gl/(.*)$|https://godbolt.org/g/$1";
        urlShortenService = "default";
        supportsLibraryCodeFilter = "false";
        remoteStorageServer = "https://godbolt.org";
      };
    };

in
writeText "compiler-explorer.defaults.properties" ''
  ${utils.attrToDot settings.timeouts}
  ${utils.attrToDot settings.cache}
  ${utils.attrToDot settings.storage}
  ${utils.attrToDot settings.tools}
  ${utils.attrToDot settings.misc}
  ${utils.attrToDot settings.privacy}
  ${utils.attrToDot settings.remote}
''
