# Nixpkgs Review Checklist

This is a list of things to look out for when reviewing PRs. A PR satisfying all of these points doesn't mean it's suitable to be merged, nor does failing a point mean it's unsuitable, rather this is meant to help centralize the list that every nixpkgs reviewer eventually starts to make. More important entries should be towards the top, even if they are only relevant to very few PRs (use your best judgment). This is not to duplicate the various contributing guidelines, although items such as "If the PR touches files in `pkgs/development/python-modules`, review `doc/languages-frameworks/python.section.md`" are useful, as these files change over time and reminders to review them are useful.

 * Even if ofborg shows the PR as evaluating correctly, it's possible that other changes to nixpkgs have since made it cause evaluation errors. If the PR is over one month old and it touches non-package files, suggest rebasing it on top of the latest `master`, `staging`, or `staging-next`, as applicable.
 * If the PR touches files in `pkgs/development/python-modules`, review `doc/languages-frameworks/python.section.md`
 * If the PR touches files in `pkgs/applications/editors/vscode/extensions`, review `pkgs/applications/editors/vscode/extensions/README.md`
