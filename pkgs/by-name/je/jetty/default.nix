{
  lib,
  maven,
  fetchFromGitHub,
  jdk17_headless,
  nix-update-script,
}:

let
  generic =
    {
      version,
      hash,
      mvnHash,
    }:
    maven.buildMavenPackage {
      pname = "jetty";

      inherit version mvnHash;

      src = fetchFromGitHub {
        owner = "jetty";
        repo = "jetty.project";
        tag = "jetty-${version}";
        inherit hash;
      };

      mvnJdk = jdk17_headless;

      postPatch = ''
        # remove the mimir caching extension
        rm .mvn/extensions.xml
      '';

      mvnParameters = lib.escapeShellArgs [
        # skip checkstyle, enforcer, spotbugs, spotless and tests
        "-Pfast"
        # only build jetty-home and the modules it depends on
        "--projects=jetty-home"
        "--also-make"
        # requires a git checkout
        "-Dmaven.buildNumber.skip=true"
        # njord writes to user.home, which is not writable on darwin
        "-Dnjord.enabled=false"
        # the build cache is not reproducible
        "-Dmaven.build.cache.enabled=false"
        # make the build timestamp deterministic
        "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z"
      ];

      # The upstream test suite is very large, needs network access and
      # containers, and would also run in the fetchedMavenDeps derivation.
      doCheck = false;

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -r jetty-home/target/jetty-home/{etc,lib,modules,start.jar} $out

        runHook postInstall
      '';

      passthru.updateScript = nix-update-script {
        extraArgs = [
          "--version-regex"
          "^jetty-(${lib.versions.major version}\\.[0-9.]+)$"
        ];
      };

      meta = {
        changelog = "https://github.com/jetty/jetty.project/releases/tag/jetty-${version}";
        description = "Web server and servlet container";
        homepage = "https://jetty.org/";
        platforms = lib.platforms.all;
        sourceProvenance = with lib.sourceTypes; [
          fromSource
          binaryBytecode
        ];
        license = with lib.licenses; [
          asl20
          epl20
        ];
        maintainers = with lib.maintainers; [
          emmanuelrosa
          anthonyroussel
        ];
      };
    };

in
{
  jetty_12 = generic {
    version = "12.1.14";
    hash = "sha256-fI52BAW1ZEtsEF6ByLmvtmFkAq+xvo1Eq4q+pHPuSG0=";
    mvnHash = "sha256-2MsV50zA3nluSrq93hZulC7r3oCDdwnZbEXWvmeCl18=";
  };
}
