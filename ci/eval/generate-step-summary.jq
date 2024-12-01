def truncate(xs; n):
  if xs | length > n then xs[:n] + ["..."]
  else xs
  end;

def itemize_packages(xs):
  truncate(xs; 3000) | map("- \(. )") | join("\n");

def section(title; xs):
  "## " + title + " (" + (xs | length | tostring) + ")\n" + itemize_packages(xs);

section("Added"; .attrdiff.added) + "\n\n" +
section("Removed"; .attrdiff.removed) + "\n\n" +
section("Changed"; .attrdiff.changed)
