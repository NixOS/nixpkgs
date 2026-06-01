"""
Extract the coordinates of the plugins that a given Maven distribution uses
*implicitly* when a project does not pin their versions:

  * the lifecycle bindings baked into ``maven-core``
    (``META-INF/plexus/*.xml``), e.g. resources, compiler, surefire, jar,
    install, deploy, clean, site and the packaging specific plugins
    (war, ear, ejb, rar, plugin); and
  * the ``pluginManagement`` versions from the super POM shipped in
    ``maven-model-builder`` (e.g. assembly, dependency, antrun, release).

These versions are baked into each Maven release and therefore change on
every Maven upgrade. The coordinates are printed one
``groupId:artifactId:version`` per line on stdout.
"""

import glob
import os
import re
import sys
import xml.etree.ElementTree as ET
import zipfile

# Lifecycle bindings reference plugins as group:artifact:version[:goal].
GAV_RE = re.compile(
    r"org\.apache\.maven\.plugins:maven-[\w-]+-plugin:[0-9][\w.-]*"
)


def localname(tag):
    return tag.rsplit("}", 1)[-1]


def from_plexus(core_jar):
    gavs = set()
    with zipfile.ZipFile(core_jar) as jar:
        for name in jar.namelist():
            if name.startswith("META-INF/plexus/") and name.endswith(".xml"):
                text = jar.read(name).decode("utf-8", "replace")
                gavs.update(GAV_RE.findall(text))
    return gavs


def from_super_pom(model_jar):
    gavs = set()
    with zipfile.ZipFile(model_jar) as jar:
        names = (n for n in jar.namelist() if n.endswith("pom-4.0.0.xml"))
        for name in names:
            root = ET.fromstring(jar.read(name))
            for plugin in root.iter():
                if localname(plugin.tag) != "plugin":
                    continue
                coords = {"groupId": "org.apache.maven.plugins"}
                for child in plugin:
                    field = localname(child.tag)
                    if field in ("groupId", "artifactId", "version"):
                        coords[field] = (child.text or "").strip()
                artifact = coords.get("artifactId")
                version = coords.get("version", "")
                # Skip plugins without a concrete version (${...} refs).
                if artifact and version and not version.startswith("${"):
                    gavs.add(f"{coords['groupId']}:{artifact}:{version}")
    return gavs


def main(lib_dir):
    gavs = set()
    for jar in glob.glob(os.path.join(lib_dir, "maven-core-*.jar")):
        gavs |= from_plexus(jar)
    for jar in glob.glob(os.path.join(lib_dir, "maven-model-builder-*.jar")):
        gavs |= from_super_pom(jar)
    for gav in sorted(gavs):
        print(gav)


if __name__ == "__main__":
    main(sys.argv[1])
