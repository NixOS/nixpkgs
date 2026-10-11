// @ts-check

// near exact copy of the tail of arduino-ide-extension/scripts/download-examples.js
// (everything after the git clone/checkout)
(async () => {
  const path = require('node:path');
  const { promises: fs } = require('node:fs');
  const destination = process.argv[2];
  if (!destination) {
    console.error('usage: node generate-examples-json.js <destination>');
    process.exit(1);
  }
  const isSketch = async (pathLike) => {
    try {
      const names = await fs.readdir(pathLike);
      const dirName = path.basename(pathLike);
      return names.indexOf(`${dirName}.ino`) !== -1;
    } catch (e) {
      if (e.code === 'ENOTDIR') {
        return false;
      }
      throw e;
    }
  };
  const examples = [];
  const categories = await fs.readdir(destination);
  const visit = async (pathLike, container) => {
    const stat = await fs.lstat(pathLike);
    if (stat.isDirectory()) {
      if (await isSketch(pathLike)) {
        container.sketches.push({
          name: path.basename(pathLike),
          relativePath: path.relative(destination, pathLike),
        });
      } else {
        const names = await fs.readdir(pathLike);
        for (const name of names) {
          const childPath = path.join(pathLike, name);
          if (await isSketch(childPath)) {
            container.sketches.push({
              name,
              relativePath: path.relative(destination, childPath),
            });
          } else {
            const child = { label: name, children: [], sketches: [] };
            container.children.push(child);
            await visit(childPath, child);
          }
        }
      }
    }
  };
  for (const category of categories) {
    const example = { label: category, children: [], sketches: [] };
    await visit(path.join(destination, category), example);
    examples.push(example);
  }
  await fs.writeFile(
    path.join(destination, 'examples.json'),
    JSON.stringify(examples, null, 2),
    { encoding: 'utf8' }
  );
  console.log(`Generated output to ${path.join(destination, 'examples.json')}`);
})();
