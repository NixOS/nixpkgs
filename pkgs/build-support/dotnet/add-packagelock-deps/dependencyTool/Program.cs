using Microsoft.Build.Evaluation;
using Microsoft.Build.Locator;
using System.Collections;

var globalProperties = new Dictionary<string,string>();
foreach (DictionaryEntry pair in Environment.GetEnvironmentVariables()) {
	globalProperties.Add($"{pair.Key}", $"{pair.Value}");
}

MSBuildLocator.RegisterDefaults();

var projectPaths = args
	.Select(Path.GetFullPath);

var refs = projectPaths
	.SelectMany(GetProjectReferences)
	.Concat(projectPaths)
	.Select(p => GetPackageLock(p))
	.Select(p => Path.GetRelativePath(".", p));

Console.WriteLine(System.Text.Json.JsonSerializer.Serialize(refs));

//====================//

IEnumerable<string> GetProjectReferences(string projectPath)
{
	var rootPath = Path.GetDirectoryName(projectPath) ?? throw new InvalidOperationException();

	using var pc = new ProjectCollection(globalProperties);
	var proj = pc.LoadProject(projectPath);

	foreach (ProjectItem pi in proj.Items)
	{
		if (pi.ItemType == "ProjectReference")
		{
			var include = pi.EvaluatedInclude;
			var refPath = Path.Combine(rootPath, include);

			yield return Path.GetFullPath(refPath);

			foreach (var r in GetProjectReferences(refPath))
			{
				yield return r;
			}
		}
	}
}

string GetPackageLock(string projectPath)
{
	var rootPath = Path.GetDirectoryName(projectPath) ?? throw new InvalidOperationException();

	using var pc = new ProjectCollection(globalProperties);
	var proj = pc.LoadProject(projectPath);

	var relPath = proj.GetPropertyValue("NuGetLockFilePath");
	if (string.IsNullOrWhiteSpace(relPath))
	{
		relPath = "packages.lock.json";
	}

	return Path.Combine(rootPath, relPath);
}

