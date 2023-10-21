- If the user has a custom shell enabled via `users.users.${USERNAME}.shell = ${CUSTOMSHELL}`, the
  assertion will require them to also set `programs.${CUSTOMSHELL}.enable =
  true`. This is generally safe behavior, but for anyone needing to opt out from
  the check `users.users.${USERNAME}.ignoreShellProgramCheck = true` will do the job.
