{
  stdenv,
  lib,
  fetchFromGitHub,
  installShellFiles,
  testers,
  nix-update-script,
  nb,
}:

stdenv.mkDerivation rec {
  pname = "nb";
  version = "7.15.0";

  src = fetchFromGitHub {
    owner = "xwmx";
    repo = "nb";
    rev = version;
    hash = "sha256-dZl/WYmm+UTPYuvVf+7zvU7ms5x/cwnC56y+PIRx3Hc=";
  };

  nativeBuildInputs = [ installShellFiles ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin/
    mv nb $out/bin/
    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion --cmd nb etc/nb-completion.{bash,zsh,fish}
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = nb;
      # Setting EDITOR to avoid: "Command line text editor not found"
      command = "EDITOR=nano nb --version";
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Command line note-taking, bookmarking, archiving, and knowledge base application";
    longDescription = ''
      `nb` creates notes in text-based formats like Markdown, Emacs Org mode,
      and LaTeX, can work with files in any format, can import and export notes
      to many document formats, and can create private, password-protected
      encrypted notes and bookmarks. With `nb`, you can write notes using Vim,
      Emacs, VS Code, Sublime Text, and any other text editor you like. `nb`
      works in any standard Linux / Unix environment, including macOS and
      Windows via WSL. Optional dependencies can be installed to enhance
      functionality, but `nb` works great without them.

      `nb` is also a powerful text-based CLI bookmarking system. Page
      information is automatically downloaded, compiled, and saved into normal
      Markdown documents made for humans, so bookmarks are easy to edit just
      like any other note.

      `nb` uses Git in the background to automatically record changes and sync
      notebooks with remote repositories. `nb` can also be configured to sync
      notebooks using a general purpose syncing utility like Dropbox so notes
      can be edited in other apps on any device.

      `nb` is designed to be portable, future-focused, and vendor independent,
      providing a full-featured and intuitive experience within a highly
      composable user-centric text interface. The entire program is a single
      well-tested shell script that can be installed, copied, or curled almost
      anywhere and just work, using progressive enhancement for various
      experience improvements in more capable environments. `nb` works great
      whether you have one notebook with just a few notes or dozens of
      notebooks containing thousands of notes, bookmarks, and other items. `nb`
      makes it easy to incorporate other tools, writing apps, and workflows.
      `nb` can be used a little, a lot, once in a while, or for just a subset
      of features. `nb` is flexible.
    '';
    homepage = "https://xwmx.github.io/nb/";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.toonn ];
    platforms = platforms.all;
    mainProgram = "nb";
  };
}
