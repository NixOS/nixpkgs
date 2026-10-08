{
  emacs-application-framework,
}:

let

  withApplications =
    enabledApps:
    emacs-application-framework.override {
      inherit enabledApps;
    };

in

{
  inherit withApplications;
}
