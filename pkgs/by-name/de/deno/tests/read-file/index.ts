// trim 'file://' prefix
const thisDir = Deno.mainModule.substring(7, Deno.mainModule.length);
const getParent = (path: string) => path.substring(0, path.lastIndexOf("/"))
const text = await Deno.readTextFile(getParent(thisDir) + "/data.txt");
console.log(text);
