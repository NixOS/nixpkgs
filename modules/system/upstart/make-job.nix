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
