#include <bgfx/bgfx.h>

int main()
{
    bgfx::Init init;
    init.type = bgfx::RendererType::Noop;
    init.swapChain.width = 1;
    init.swapChain.height = 1;
    if (!bgfx::init(init)) {
        return 1;
    }
    bgfx::touch(0);
    bgfx::frame();
    bgfx::shutdown();
    return 0;
}
