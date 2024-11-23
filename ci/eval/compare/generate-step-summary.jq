def truncate(xs; n):
  if xs | length > n then xs[:n] + ["..."]
  else xs
  end;

def itemize_packages(xs):
  # we truncate the list to stay below the GitHub limit of 1MB per step summary.
  truncate(xs; 3000) | map("- [\(.)](https://search.nixos.org/packages?channel=unstable&show=\(.)&from=0&size=50&sort=relevance&type=packages&query=\(.))") | join("\n");

def section(title; xs):
  "<details> <summary>" + title + " (" + (xs | length | tostring) + ")</summary>\n\n" + itemize_packages(xs) + "</details>";

section("Added packages"; .attrdiff.added) + "\n\n" +
section("Removed packages"; .attrdiff.removed) + "\n\n" +
section("Changed packages"; .attrdiff.changed)
