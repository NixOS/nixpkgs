Please be _very_ careful when changing the content of `yarn-berry-supported-archs.json`.
This file is used to instruct `yarn-berry` which packages to fetch and install into our
offline cache. If this file is changed, _ALL_ cached offline contents for `yarn-berry`
are invalidated and will need their hashes to be updated!
