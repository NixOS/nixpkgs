{
  cmake,
  fetchFromGitHub,
  glm,
  httplib,
  lib,
  openssl,
  plog,
  runCommand,
  sdl3,
  stdenv,
  unstableGitUpdater,
  writeShellScript,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "descent3-unwrapped";
  # I’m using an unstable version here because we need to use -additionaldir in
  # the wrapped version of Descent 3. Once there’s a stable version of Descent
  # 3 that supports the -additionaldir command-line option, we can stop using
  # an unstable version of Descent 3.
  version = "1.5.0-beta-unstable-2025-06-15";
  src = fetchFromGitHub {
    owner = "DescentDevelopers";
    repo = "Descent3";
    rev = "0171d7b76a0c6d77908169af8ff3ea8d4d1cd930";
    leaveDotGit = true;
    # Descent 3 is supposed to display its Git commit hash in the bottom right
    # corner of the main menu. That feature only works if either the .git
    # directory or a git-hash.txt file exists at build time. We don’t want .git
    # to exist at build time (see #8567), so we create a git-hash.txt file and
    # then delete the .git directory.
    #
    # Technically, we could simplify the code by reading the value of src.rev.
    # src.rev contains a Git commit hash at the moment, but it won’t contain a
    # Git commit hash in the future when we switch to a stable version of
    # Descent 3.
    #
    # Upstream expects git-hash.txt to contain a short commit hash, but I’ve
    # decided to use a full commit hash. Full commit hashes are more
    # reproducible. The short hash “1234” might correspond to one commit today,
    # but correspond to two commits tomorrow. Full commit hashes don’t have
    # that problem.
    #
    # Also, upstream expects git-hash.txt to contain no newlines. If
    # git-hash.txt contains a newline, then Descent 3 will fail to build.
    postFetch = ''
      cd "$out"
      git rev-parse --verify HEAD | tr --delete '\n' > git-hash.txt
      rm -r .git
    '';
    hash = "sha256-/lJlrV1OswlNa8nMfiUdQof7zb+wgwI97MwNCZFNd8g=";
  };

  hardeningDisable = [ "format" ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    glm
    httplib
    openssl
    plog
    sdl3
    zlib
  ];
  cmakeFlags = [ "-DFORCE_PORTABLE_INSTALL=OFF" ];
  # This is a workaround for a problem that will eventually get fixed upstream.
  postInstall = ''
    cd "$out"
    mv lib/* share/
    rmdir lib
  '';

  passthru = {
    # The idea here is to make sure that we don’t forget to update meta.license
    # when reviewing a pull request from @r-ryantm.
    tests.licenseInfoIsUpToDate = runCommand "${pname}-license-info-is-up-to-date" { } ''
      function on_success {
        echo Test succeeded. > "$out"
      }

      function on_failure {
        echo \
          It looks like at least one of Descent 3’s licensing-related files \
          changed. Before you continue to update this package, you should \
          check to see if meta.license needs to be updated. Once you’ve done \
          that, you can update the hashes in the \
          passthru.tests.licenseInfoIsUpToDate script and then try running the \
          package tests again. >&2
        return 1
      }

      cd ${lib.strings.escapeShellArg src}
      sha256sum --check << EOF && on_success || on_failure
        8b1ba204bb69a0ade2bfcf65ef294a920f6bb361b317dba43c7ef29d96332b9b  LICENSE
        55d65dbf5d785111cf7029941cb7f72dbef084509e6126bcc58b6bb20203f8c6  THIRD_PARTY.md
      EOF
    '';
    updateScript = unstableGitUpdater {
      shallowClone = false;
      # unstableGitUpdater assumes that the version number should be 0 if there
      # isn’t any tags in the repo’s default branch. For most packages, that is
      # the correct decision, but for Descent 3 it’s not. Descent 3’s source
      # code lived in private repos until 2024. In 2024, a new public repo was
      # created [1], but the old commit history wasn’t imported into the new
      # repo. Version 1.5.0-beta from 2005 [2] was the last release that was
      # created from one of the private repos.*
      #
      # *Technically, there was one release that came after the 2005 one. There
      # was a Linux version and a macOS version of Descent 3 that were released
      # on Steam in 2020 [3][4][5]. Those versions don’t count because they
      # haven’t been fully merged into the public repo yet [6].
      #
      # [1]: <https://github.com/DescentDevelopers/Descent3/commit/637df31ca1e47371fb8ca822f928734c13afd8cf>
      # [2]: <http://descent3.com/downloads.php>
      # [3]: <https://www.patreon.com/posts/project-descent-33611585>
      # [4]: <https://steamdb.info/depot/273592>
      # [5]: <https://steamdb.info/depot/273593>
      # [6]: <https://github.com/DescentDevelopers/Descent3/issues/240>
      tagConverter = writeShellScript "${pname}-tag-converter.sh" ''
        read -r input_tag
        if [ "$input_tag" = 0 ]
        then
          printf '%s' 1.5.0-beta
        else
          printf '%s' "$input_tag"
        fi
      '';
    };
  };

  meta = {
    description = "Game engine for a 6DOF first-person shooter";
    homepage = "https://github.com/DescentDevelopers/Descent3";
    license = with lib.licenses; [
      # See LICENSE and header that’s at the top of many source files.
      gpl3Plus
      # See THIRD_PARTY.md.
      isc
      mit
    ];
    mainProgram = "Descent3";
    maintainers = [ lib.maintainers.jayman2000 ];
    platforms = lib.platforms.all;
    badPlatforms = [
      # Descent 3 stores modules in HOG2 archives. It extracts those modules
      # and then tries to dlopen() them at runtime.
      lib.systems.inspect.platformPatterns.isStatic
      # When you build Descent 3 on Darwin, it produces a different directory
      # structure (no bin/ directory) [1]. I’m sure that this derivation could be
      # updated to account for that different directory structure, but I don’t
      # have any Darwin systems to test things on at the moment.
      #
      # [1]: <https://logs.ofborg.org/?key=nixos/nixpkgs.355710&attempt_id=747dd630-5068-4ba9-9c50-6f150634ef1a>
    ]
    ++ lib.platforms.darwin;
  };
}
