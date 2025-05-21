from functools import cache
from typing import Any
from pathlib import Path

_frozen_classes: dict[type, type] = {}

# make a derived class freezable (ie, disallow modifications).
# we do this by changing the class of an instance at runtime when freeze()
# is called, providing a derived class that is exactly the same except
# for a __setattr__ that raises an error when called. this beats having
# a field for frozenness and an unconditional __setattr__ that checks this
# field because it does not insert anything into the class dict.
class Freezeable:
    def freeze(self) -> None:
        cls = type(self)
        if not (frozen := _frozen_classes.get(cls)):
            def __setattr__(instance: Any, n: str, v: Any) -> None:
                raise TypeError(f'{cls.__name__} is frozen')
            frozen = type(cls.__name__, (cls,), {
                '__setattr__': __setattr__,
            })
            _frozen_classes[cls] = frozen
        self.__class__ = frozen

@cache
def relative_path_from(origin: str, to: str) -> str:
    path_to = Path(origin)
    path_from = Path(to)

    if path_to.root != path_from.root:
        path_to = path_to.absolute()
        path_from = path_from.absolute()

    nb_back = 0
    while not path_from.is_relative_to(path_to.parent):
        print(path_to, path_from)

        path_to = path_to.parent
        nb_back += 1

    backtrack = "/".join([".." for _ in range(0, nb_back)])

    return str(backtrack / path_from.relative_to(path_to.parent))
