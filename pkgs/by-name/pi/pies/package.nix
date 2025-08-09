{
  lib,
  stdenv,
  fetchurl,
  libxcrypt,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pies";
  version = "1.8";

  src = fetchurl {
    url = "mirror://gnu/pies/pies-${finalAttrs.version}.tar.bz2";
    hash = "sha256-ZSi00WmC6il4+aSohqFKrKjtp6xFXYE7IIRGVwFmHWw=";
  };

  buildInputs = [ libxcrypt ];

  patches = [ ./stdlib.patch ];

  postPatch = ''
    substituteInPlace configure \
      --replace-fail "gl_cv_func_memchr_works=\"guessing no\"" "gl_cv_func_memchr_works=yes"
  '';

  configureFlags = [ "--sysconfdir=/etc" ];

  hardeningDisable = [ "format" ];

  doCheck = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Program invocation and execution supervisor";
    longDescription = ''
      The name Pies (pronounced "p-yes") stands for Program Invocation and
      Execution Supervisor.  This utility starts and controls execution of
      external programs, called components.  Each component is a
      stand-alone program, which is executed in the foreground.  Upon
      startup, pies reads the list of components from its configuration
      file, starts them, and remains in the background, controlling their
      execution.  If any of the components terminates, the default action
      of Pies is to restart it.  However, it can also be programmed to
      perform a variety of another actions such as, e.g., sending mail
      notifications to the system administrator, invoking another external
      program, etc.

      Pies can be used for a wide variety of tasks.  Its most obious use
      is to put in backgound a program which normally cannot detach itself
      from the controlling terminal, such as, e.g., minicom.  It can
      launch and control components of some complex system, such as
      Jabberd or MeTA1 (and it offers much more control over them than the
      native utilities).  Finally, it can replace the inetd utility!
    '';
    homepage = "https://www.gnu.org/software/pies/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.gnu ++ lib.platforms.linux;
    broken = stdenv.hostPlatform.system == "aarch64-linux";
    maintainers = [ ];
  };
})
