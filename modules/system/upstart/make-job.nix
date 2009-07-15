{runCommand}: job:

(
  if job ? jobDrv then
    job.jobDrv
  else
    (
      runCommand ("upstart-" + job.name)
        { inherit (job) job;
          jobName = job.name;
          buildHook = if job ? buildHook then job.buildHook else "true";
        }
        "eval \"$buildHook\"; ensureDir $out/etc/event.d; echo \"$job\" > $out/etc/event.d/$jobName"
    )
)

//

{
  # Allow jobs to declare user accounts that should be created.
  users = if job ? users then job.users else [];
  
  # Allow jobs to declare groups that should be created.
  groups = if job ? groups then job.groups else [];

  passthru = if job ? passthru then job.passthru else {};
}
